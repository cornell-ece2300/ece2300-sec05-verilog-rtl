#!/usr/bin/env python3
"""
Work out which Verilog files a test file covers, so the linter knows which
files to run on.

Starting from the test file, we follow `include` statements and collect
everything reachable. No filtering happens here: rulesets.yaml decides which
of the collected files actually get rules applied, so system includes and
untracked modules fall out on their own.
"""

import os
import re
import sys
from collections import deque
from pathlib import Path
from typing import List, Optional

# any `include "..." which are used used to walk dependencies
ANY_INCLUDE_RE = re.compile(r'`include\s+"([^"]+)"')

def find_all_includes(content: str) -> List[str]:
    """Return every `include path in the file."""
    return ANY_INCLUDE_RE.findall(content)

def resolve_include(include_path: str, include_dirs: List[str]) -> Optional[Path]:
    """
    Turn an `include path into a real file, searching each -I directory.

    Returns None if it is not found. That is not an error: system includes
    live outside the lab tree and we simply do not lint them.
    """
    for directory in include_dirs:
        candidate = Path(os.path.join(directory, include_path)).resolve()
        if candidate.is_file():
            return candidate
    return None


def collect_files(root_file: Path, include_dirs: List[str]) -> List[Path]:
    """
    Return every file that should be linted for the given top or test file.

    The list starts with the -I file and continues down by finding includes. 
    Post-order means a file is appended only after everything it includes has
    been appended, so the lowest-level modules are linted before the modules
    built out of them. This is important so that error in the lowest hierarchy
    can be viewed before it potentially influences higher hierarchy files tht include it.

    Whether a collected file actually gets any rules applied is by rulesets.yaml
    """
    root = Path(root_file).resolve()
    if not root.is_file():
        print(f"Error: file not found: {root}", file=sys.stderr)
        return []

    seen = set()
    # Collected is the filepath list of the unique included files
    collected = []

    def visit(path: Path) -> None:
        if path in seen:
            return
        seen.add(path) # mark as seen before recursing
        try:
            content = path.read_text(encoding="utf-8")
        except OSError as e:
            print(f"Warning: could not read {path}: {e}", file=sys.stderr)
            return
        for include_path in find_all_includes(content):
            dependency = resolve_include(include_path, include_dirs)
            if dependency is not None:
                visit(dependency)
        collected.append(path) # append after children

    visit(root)
    return collected

if __name__ == "__main__":
    # Debug helper: print the file list without running the linter
    #   python3 collect_files.py -I . lab1/test/DisplayUnopt_GL-test.v
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", help="a *-test.v file")
    parser.add_argument(
        "-I", "--include-dir", action="append", default=["."],
        help="directory to search for `include files (repeatable)",
    )
    args = parser.parse_args()

    for path in collect_files(Path(args.file), args.include_dir):
        print(path)
