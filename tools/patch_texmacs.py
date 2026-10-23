#!/usr/bin/env python3
"""Apply exact, byte-preserving replacements to native TeXmacs files.

TeXmacs' native format uses its universal (Cork-based) 8-bit encoding, not
UTF-8. This program never decodes the document. Patch strings are supplied
as Unicode only as a convenient notation: code points U+0000 through U+00FF
map one-to-one to bytes 0x00 through 0xFF.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Sequence


class PatchError(Exception):
    """A safe patch could not be applied."""


@dataclass(frozen=True)
class Operation:
    old: bytes
    new: bytes
    expected: int = 1


def byte_string(value: str, field: str) -> bytes:
    """Map U+0000..U+00FF one-to-one to bytes, without text conversion."""

    try:
        return value.encode("latin-1")
    except UnicodeEncodeError as error:
        character = value[error.start]
        raise PatchError(
            f"{field} contains {character!r} (U+{ord(character):04X}), which cannot "
            "denote one Cork byte; use native TeXmacs symbol syntax or an exact "
            "\\u00XX byte escape"
        ) from error


def operation_from_json(value: Any, index: int) -> Operation:
    if not isinstance(value, dict):
        raise PatchError(f"operation {index} must be a JSON object")

    extra = set(value) - {"old", "new", "expected"}
    if extra:
        names = ", ".join(sorted(extra))
        raise PatchError(f"operation {index} has unknown field(s): {names}")
    if "old" not in value or "new" not in value:
        raise PatchError(f"operation {index} must contain both 'old' and 'new'")
    if not isinstance(value["old"], str) or not isinstance(value["new"], str):
        raise PatchError(f"operation {index} fields 'old' and 'new' must be strings")

    expected = value.get("expected", 1)
    if isinstance(expected, bool) or not isinstance(expected, int) or expected < 1:
        raise PatchError(f"operation {index} field 'expected' must be a positive integer")

    old = byte_string(value["old"], f"operation {index} field 'old'")
    new = byte_string(value["new"], f"operation {index} field 'new'")
    if not old:
        raise PatchError(f"operation {index} field 'old' must not be empty")
    if old == new:
        raise PatchError(f"operation {index} would not change anything")
    return Operation(old=old, new=new, expected=expected)


def operations_from_json(text: str) -> list[Operation]:
    try:
        value = json.loads(text)
    except json.JSONDecodeError as error:
        raise PatchError(f"invalid JSON patch: {error}") from error

    if isinstance(value, dict):
        extra = set(value) - {"operations"}
        if extra:
            names = ", ".join(sorted(extra))
            raise PatchError(f"JSON patch has unknown top-level field(s): {names}")
        value = value.get("operations")
    if not isinstance(value, list) or not value:
        raise PatchError("JSON patch must be a non-empty list of operations")
    return [operation_from_json(item, index) for index, item in enumerate(value, 1)]


def apply_operations(data: bytes, operations: Sequence[Operation]) -> tuple[bytes, int]:
    """Apply operations sequentially, failing before the caller writes."""

    result = data
    replacements = 0
    for index, operation in enumerate(operations, 1):
        found = result.count(operation.old)
        if found != operation.expected:
            raise PatchError(
                f"operation {index} expected {operation.expected} match(es), "
                f"but found {found}; no file was changed"
            )
        result = result.replace(operation.old, operation.new)
        replacements += found
    return result, replacements


def assert_unchanged(path: Path, expected: bytes) -> None:
    try:
        current = path.read_bytes()
    except OSError as error:
        raise PatchError(f"could not re-read {path}: {error}") from error
    if current != expected:
        raise PatchError(
            f"{path} changed after the patch was prepared; no patch was written"
        )


def atomic_write(path: Path, data: bytes, expected: bytes) -> None:
    """Replace an unchanged path atomically, retaining available metadata."""

    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        os.close(descriptor)
        if sys.platform == "darwin":
            # macOS cp preserves ACLs and extended attributes, including the
            # Dropbox attributes present in this repository.
            copied = subprocess.run(
                ["/bin/cp", "-p", path, temporary],
                capture_output=True,
                text=True,
                check=False,
            )
            if copied.returncode:
                detail = copied.stderr.strip() or f"exit status {copied.returncode}"
                raise OSError(f"could not copy file metadata: {detail}")
        else:
            shutil.copy2(path, temporary)

        # Truncating the metadata-bearing copy keeps its xattrs while giving
        # the patched file a fresh modification time.
        with temporary.open("wb") as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        assert_unchanged(path, expected)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def patch_file(
    path: Path,
    operations: Sequence[Operation],
    *,
    dry_run: bool = False,
    backup_suffix: str | None = None,
    require_texmacs_header: bool = True,
) -> tuple[Path, int, int, int]:
    try:
        target = path.resolve(strict=True)
    except FileNotFoundError as error:
        raise PatchError(f"file does not exist: {path}") from error
    if not target.is_file():
        raise PatchError(f"not a regular file: {path}")

    try:
        original = target.read_bytes()
    except OSError as error:
        raise PatchError(f"could not read {path}: {error}") from error
    if require_texmacs_header and not original.startswith(b"<TeXmacs|"):
        raise PatchError(f"file does not have a native TeXmacs header: {path}")

    changed, replacements = apply_operations(original, operations)
    if changed == original:
        raise PatchError("patch has no net effect; no file was changed")

    backup: Path | None = None
    if backup_suffix is not None:
        if not backup_suffix or "/" in backup_suffix or os.sep in backup_suffix:
            raise PatchError("backup suffix must be a non-empty filename suffix")
        backup = target.with_name(target.name + backup_suffix)
        if backup.exists():
            raise PatchError(f"refusing to overwrite existing backup: {backup}")

    if dry_run:
        return target, replacements, len(original), len(changed)

    if backup is not None:
        try:
            assert_unchanged(target, original)
            shutil.copy2(target, backup)
        except OSError as error:
            raise PatchError(f"could not create backup {backup}: {error}") from error

    try:
        atomic_write(target, changed, original)
    except OSError as error:
        raise PatchError(f"could not replace {target}: {error}") from error
    return target, replacements, len(original), len(changed)


def load_patch(source: str) -> list[Operation]:
    if source == "-":
        return operations_from_json(sys.stdin.read())
    try:
        text = Path(source).read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise PatchError(f"could not read JSON patch {source}: {error}") from error
    return operations_from_json(text)


def positive_integer(value: str) -> int:
    try:
        number = int(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError("must be a positive integer") from error
    if number < 1:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return number


def make_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Apply exact replacements without decoding a TeXmacs file as UTF-8."
    )
    parser.add_argument("file", type=Path, help="native TeXmacs file to patch")
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument(
        "--replace",
        nargs=2,
        metavar=("OLD", "NEW"),
        help="make one replacement using the one-byte patch-string mapping",
    )
    source.add_argument(
        "--patch",
        metavar="JSON_FILE",
        help="read a JSON operation list from this UTF-8 file, or '-' for stdin",
    )
    parser.add_argument(
        "--expect",
        type=positive_integer,
        help="required match count for --replace (default: 1)",
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="validate without writing"
    )
    parser.add_argument(
        "--raw",
        action="store_true",
        help="allow another legacy 8-bit text file without a TeXmacs header",
    )
    parser.add_argument(
        "--backup",
        nargs="?",
        const=".bak",
        metavar="SUFFIX",
        help="copy the original first; default suffix: .bak",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = make_parser()
    arguments = parser.parse_args(argv)
    try:
        if arguments.replace is not None:
            expected = arguments.expect if arguments.expect is not None else 1
            old = byte_string(arguments.replace[0], "OLD")
            new = byte_string(arguments.replace[1], "NEW")
            if not old:
                raise PatchError("OLD must not be empty")
            if old == new:
                raise PatchError("OLD and NEW are identical")
            operations = [Operation(old=old, new=new, expected=expected)]
        else:
            if arguments.expect is not None:
                raise PatchError("--expect is only valid with --replace")
            operations = load_patch(arguments.patch)

        target, replacements, old_size, new_size = patch_file(
            arguments.file,
            operations,
            dry_run=arguments.dry_run,
            backup_suffix=arguments.backup,
            require_texmacs_header=not arguments.raw,
        )
    except PatchError as error:
        parser.exit(2, f"error: {error}\n")

    action = "validated" if arguments.dry_run else "patched"
    note = " (dry run; no file written)" if arguments.dry_run else ""
    print(
        f"{action} {target}: {len(operations)} operation(s), "
        f"{replacements} replacement(s), {old_size} -> {new_size} bytes{note}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
