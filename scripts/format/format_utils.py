# Utility functions used by all the format scripts.
#
# Author : Anthony Song
# Last Maintained : Jun 30, 2026
#

import os
import subprocess
import sys
from pathlib import Path

VERILOG_EXTS = (".v", ".sv", ".svh")

# Verible is resolved from PATH, not from a vendored tree, so the formatter
# follows whichever ece2300-verible build the environment sets up.
VERIBLE_LINT_EXE = "verible-verilog-lint"
VERIBLE_FORMAT_EXE = "verible-verilog-format"


def print_error(message):
  # Blank line above and below. These land in the middle of a wall of make and
  # Verible output, where an unpadded message is easy to scroll straight past.
  print(f"\n{message}\n", file=sys.stderr)


def exit_error(message):
  print_error(message)
  sys.exit(1)


def validate_file(path, tool_name):
  path = Path(path)
  if not path.is_file():
    print_error(f"{tool_name}: Not a file: {path}")
    return None
  if path.suffix not in VERILOG_EXTS:
    print_error(
      f"{tool_name}: Not a Verilog file (expected {VERILOG_EXTS}): {path}"
    )
    return None
  return path.resolve()


def ensure_file_committed(path, tool_name):
  # Every pass overwrites the file in place, so refuse to touch anything that
  # is not already committed. That way `git checkout` is always a way back if
  # the formatter mangles something.
  try:
    result = subprocess.run(
      ["git", "status", "--porcelain", "--ignored", "--", str(path)],
      cwd=path.parent,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      universal_newlines=True,
      check=False,
    )
  except FileNotFoundError:
    exit_error(f"{tool_name}: Error: git not found on PATH.")

  if result.returncode != 0:
    exit_error(f"{tool_name}: Error: {path} is not inside a git repository.")

  status = result.stdout.strip()
  if not status:
    return

  # Shown relative to where the student ran make, so the hint is copy-pastable.
  try:
    rel = Path(os.path.relpath(path))
  except ValueError:
    rel = path

  # "??" is untracked, "!!" is gitignored: neither has a committed copy, so
  # git checkout has nothing to restore and the fix is to commit it instead.
  if status.startswith(("??", "!!")):
    exit_error(
      f"{tool_name}: Error: {rel} is not committed to git.\n"
      f"Commit it first, then format."
    )

  exit_error(
    f"{tool_name}: Error: {rel} has uncommitted changes.\n"
    f"Commit them first (do not stash), then format. You can then always undo\n"
    f"the formatting with:\n"
    f"  git checkout -- {rel}"
  )

def collapse_extra_blank_lines(text):
  # Collapse runs of 2+ blank lines down to a single blank line.
  if not text:
    return text

  lines = text.splitlines(keepends=True)
  out = []
  blank_run = 0
  for line in lines:
    if not line.strip():
      blank_run += 1
      if blank_run <= 1:
        out.append(line)
    else:
      blank_run = 0
      out.append(line)
  return "".join(out)
