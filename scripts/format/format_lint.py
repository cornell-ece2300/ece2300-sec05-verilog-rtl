#!/usr/bin/env python3
#=========================================================================
# ece2300-format-lint <file>
#=========================================================================
#
# Pass 1: Lint with Verible + ECE 2300 class rules.
#
# Author : Anthony Song
# Last Maintained : Jun 30, 2026
#

import argparse
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from format_utils import (
  VERIBLE_LINT_EXE,
  collapse_extra_blank_lines,
  print_error,
  validate_file,
)

TOOL_NAME = "ece2300-format-lint"

# Verible RE2 naming-style patterns (see verible verilog/tools/lint README).
ECE2300_LINT_SNAKE_CASE_RE = "[a-z_0-9]+"
ECE2300_LINT_ALL_CAPS_RE = "[A-Z_0-9]+"
# localparams: snake_case or ALL_CAPS (e.g. jr_targ, MEM_SIZE).
ECE2300_LINT_LOCALPARAM_RE = (
  f"{ECE2300_LINT_SNAKE_CASE_RE}|{ECE2300_LINT_ALL_CAPS_RE}"
)

# TODO: Currently using all rules marked "?", may need to remove some
VERIBLE_LINT_ARGS = [
  "--ruleset=default",
  "--rules=" + ",".join([
    "+always-comb",
    "+always-comb-blocking",
    "+always-ff-non-blocking",
    "+case-missing-default",
    "+constraint-name-style",
    "+forbid-consecutive-null-statements",
    # Outside the regions the formatter controls, line breaks are a
    # readability judgment call, so students pick their own line lengths.
    "-line-length",
    # Verible counts the port name in a named connection as a declaration, so
    # the class style `.clk (clk)` reports clk as shadowing the clk port. That
    # fires on nearly every lab file, so the rule is off until it can tell the
    # two apart.
    "-instance-shadowing",
    "+module-begin-block",
    "+module-port",
    "+no-tabs",
    "-explicit-parameter-storage-type",  # deferred / not our style
    "-no-trailing-spaces",
    "+packed-dimensions-range-ordering",
    # Verible splits key:value pairs on ';'. A '|' only ORs enum bits *inside*
    # a value, so it cannot separate pairs here. The empty localparam_style:
    # and parameter_style: clear the CamelCase/ALL_CAPS defaults, which Verible
    # would otherwise OR together with the regexes below.
    "parameter-name-style=localparam_style:"
    f";localparam_style_regex:{ECE2300_LINT_LOCALPARAM_RE}"
    f";parameter_style:"
    f";parameter_style_regex:{ECE2300_LINT_SNAKE_CASE_RE}",
    "+signal-name-style",
    "+truncated-numeric-literal",
    "-macro-name-style",
    "-explicit-begin",                      # deferred
    "-numeric-format-string-style",         # deferred
    "-one-module-per-file",                 # deferred
    "-posix-eof",                           # deferred
    "-suspicious-semicolon",                # deferred
    "-unpacked-dimensions-range-ordering",  # deferred
  ]),
  "--lint_fatal",
]

# Database of short lint error messages for students, better than default Verible messages
ECE2300_LINT_MESSAGES = {
  "always-comb": "Use always_comb instead of always @*.",
  "always-comb-blocking": "Use blocking (=) assignments in always_comb, not <=.",
  "always-ff-non-blocking": "Use nonblocking (<=) assignments in always_ff, not =.",
  "case-missing-default": "Add a default case item (unless the case is unique).",
  "constraint-name-style": "Constraint names must be lower_snake_case ending in _c.",
  "forbid-consecutive-null-statements": "Remove consecutive empty statements (;;).",
  "module-begin-block": "Do not use begin/end blocks at module level.",
  "module-port": "Use named ports (.name(sig)) when a module has more than one port.",
  "no-tabs": "Use spaces instead of tab characters.",
  "no-trailing-spaces": "Remove trailing spaces at the end of the line.",
  "packed-dimensions-range-ordering": "Declare packed ranges in decreasing order, e.g. [N-1:0].",
  "parameter-name-style": (
    "Parameter names must be snake_case; "
    "localparam names must be snake_case or ALL_CAPS."
  ),
  "signal-name-style": "Signal names must be snake_case.",
  "truncated-numeric-literal": "Numeric literal is wider than its declared bit width.",
  "lab-assignment-comments": (
    "Remove all lab assignment template comments before submitting."
  ),
  "class-comments": "Remove class-style comments before submitting.",
}

# Instructor lab-assignment comment markers (see coding-convention 6.6).
LAB_ASSIGNMENT_MARKERS = (
  "LAB ASSIGNMENT",
  "remove these lines before starting your implementation",
)
LAB_ASSIGNMENT_QUOTE_RE = re.compile(r"'{10,}")
CLASS_COMMENT_RE = re.compile(r"^\s*//\s*(class|module|task|function|typedef|interface)\b", re.IGNORECASE)

LINT_LINE_RE = re.compile(r"^(?P<location>[^:]+:\d+:\d+(?:-\d+)?): (?P<rest>.+)$")


def check_lab_assignment_comments(text, path):
  # Return lint lines for leftover instructor lab-assignment comment blocks.
  errors = []
  friendly = ECE2300_LINT_MESSAGES["lab-assignment-comments"]
  for line_no, line in enumerate(text.splitlines(), 1):
    if "//" not in line:
      continue
    body = line.split("//", 1)[1]
    upper_body = body.upper()
    if any(marker.upper() in upper_body for marker in LAB_ASSIGNMENT_MARKERS):
      errors.append(f"{path}:{line_no}:0: {friendly} [lab-assignment-comments]\n")
      continue
    if LAB_ASSIGNMENT_QUOTE_RE.search(body):
      errors.append(f"{path}:{line_no}:0: {friendly} [lab-assignment-comments]\n")
  return []
  # return errors


def check_class_comments(text, path):
  errors = []
  friendly = ECE2300_LINT_MESSAGES["class-comments"]
  for line_no, line in enumerate(text.splitlines(), 1):
    if CLASS_COMMENT_RE.match(line):
      errors.append(f"{path}:{line_no}:0: {friendly} [class-comments]\n")
  return errors


def format_lint_output(text):
  # regexs line:col:error and reprints more human friendly error message
  out = []
  for line in text.splitlines(keepends=True):
    body = line.rstrip("\n")
    nl = line[len(body):]
    m = LINT_LINE_RE.match(body)
    if not m:
      out.append(line)
      continue
    rule_m = re.search(r" \[([-\w]+)\]$", m.group("rest"))
    if not rule_m:
      out.append(line)
      continue
    rule = rule_m.group(1)
    friendly = ECE2300_LINT_MESSAGES.get(rule)
    if friendly is None:
      out.append(line)
      continue
    out.append(f"{m.group('location')}: {friendly} [{rule}]{nl}")
  return "".join(out)


def run(path):
  text = path.read_text(encoding="utf-8")
  lint_errors = []

  fixed_text = collapse_extra_blank_lines(text)
  if fixed_text != text:
    path.write_text(fixed_text, encoding="utf-8")
    text = fixed_text

  lint_errors.extend(check_lab_assignment_comments(text, path))
  lint_errors.extend(check_class_comments(text, path))
  if lint_errors:
    sys.stdout.write("\n" + "".join(lint_errors) + "\n")
    return 1

  # Invoked after the prechecks above so they can still report on a machine
  # where Verible is not installed.
  try:
    result = subprocess.run(
      [VERIBLE_LINT_EXE, *VERIBLE_LINT_ARGS, str(path)],
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      universal_newlines=True,
    )
  except FileNotFoundError:
    print_error(f"{TOOL_NAME}: Error: {VERIBLE_LINT_EXE} not found on PATH.")
    return 1

  output = format_lint_output(result.stdout + result.stderr)
  if output:
    sys.stdout.write("\n" + output + "\n")
  return result.returncode


def main(argv=None):
  ap = argparse.ArgumentParser(
    description="Lint one Verilog/SystemVerilog file with Verible + ECE 2300 rules.",
  )
  ap.add_argument(
    "file",
    help="Verilog/SystemVerilog file to lint (.v, .sv, or .svh)",
  )
  args = ap.parse_args(argv)

  path = validate_file(args.file, TOOL_NAME)
  if path is None:
    return 1

  return run(path)


if __name__ == "__main__":
  sys.exit(main())
