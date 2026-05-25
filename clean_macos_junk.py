#!/usr/bin/env python3
"""Remove macOS metadata files from a project tree.

By default this script only prints what it would delete. Pass --delete to
actually remove the files/directories.
"""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path


JUNK_FILE_NAMES = {
    ".DS_Store",
    ".AppleDouble",
    ".LSOverride",
    "Icon\r",
}

JUNK_DIR_NAMES = {
    "__MACOSX",
    ".Spotlight-V100",
    ".TemporaryItems",
    ".Trashes",
    ".fseventsd",
}

SKIP_DIR_NAMES = {
    ".git",
}


def is_junk(path: Path) -> bool:
    name = path.name
    return name in JUNK_FILE_NAMES or name in JUNK_DIR_NAMES or name.startswith("._")


def is_skipped(path: Path) -> bool:
    return any(part in SKIP_DIR_NAMES for part in path.parts)


def collect_junk(root: Path) -> list[Path]:
    junk: list[Path] = []

    for path in root.rglob("*"):
        if is_skipped(path.relative_to(root)):
            continue
        if is_junk(path):
            junk.append(path)

    # Delete children before parents when nested junk directories exist.
    return sorted(junk, key=lambda item: len(item.parts), reverse=True)


def remove_path(path: Path) -> None:
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink(missing_ok=True)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Clean macOS metadata files from a directory tree."
    )
    parser.add_argument(
        "root",
        nargs="?",
        default=".",
        help="Directory to clean. Defaults to the current directory.",
    )
    parser.add_argument(
        "--delete",
        action="store_true",
        help="Actually delete matched files. Without this, only prints matches.",
    )
    args = parser.parse_args()

    root = Path(args.root).expanduser().resolve()
    if not root.exists() or not root.is_dir():
        print(f"Not a directory: {root}")
        return 2

    junk = collect_junk(root)
    if not junk:
        print(f"No macOS junk found under: {root}")
        return 0

    action = "Deleting" if args.delete else "Would delete"
    failed: list[tuple[Path, OSError]] = []

    for path in junk:
        print(f"{action}: {path}")
        if args.delete:
            try:
                remove_path(path)
            except OSError as exc:
                failed.append((path, exc))

    if not args.delete:
        print("\nDry run only. Re-run with --delete to remove these paths.")
    elif failed:
        print("\nSome paths could not be removed:")
        for path, exc in failed:
            print(f"- {path}: {exc}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
