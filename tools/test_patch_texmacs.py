from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from patch_texmacs import (
    Operation,
    PatchError,
    atomic_write,
    operations_from_json,
    patch_file,
)


class PatchTexmacsTests(unittest.TestCase):
    def test_preserves_unmatched_cork_bytes(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "sample.tm"
            original = b"<TeXmacs|2.1.4>\n<body|H\xf4tel and sentinel \x80>\n"
            path.write_bytes(original)

            patch_file(path, [Operation(b"H\xf4tel", b"H\xf4tels")])

            self.assertEqual(
                path.read_bytes(),
                b"<TeXmacs|2.1.4>\n<body|H\xf4tels and sentinel \x80>\n",
            )

    def test_json_u00_escape_maps_to_one_byte(self) -> None:
        operations = operations_from_json(
            r'''[{"old": "H\u00f4tel", "new": "inn", "expected": 1}]'''
        )
        self.assertEqual(operations, [Operation(b"H\xf4tel", b"inn")])

    def test_count_failure_does_not_modify_file(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "sample.tm"
            original = b"<TeXmacs|2.1.4>\n<body|two two>\n"
            path.write_bytes(original)

            with self.assertRaisesRegex(PatchError, "expected 1 match.*found 2"):
                patch_file(path, [Operation(b"two", b"three")])

            self.assertEqual(path.read_bytes(), original)

    def test_batch_failure_is_transactional(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "sample.tm"
            original = b"<TeXmacs|2.1.4>\n<body|alpha beta>\n"
            path.write_bytes(original)
            operations = [
                Operation(b"alpha", b"gamma"),
                Operation(b"missing", b"value"),
            ]

            with self.assertRaises(PatchError):
                patch_file(path, operations)

            self.assertEqual(path.read_bytes(), original)

    def test_dry_run_does_not_modify_file(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "sample.tm"
            original = b"<TeXmacs|2.1.4>\n<body|old>\n"
            path.write_bytes(original)

            _, replacements, old_size, new_size = patch_file(
                path, [Operation(b"old", b"new text")], dry_run=True
            )

            self.assertEqual(replacements, 1)
            self.assertEqual((old_size, new_size), (len(original), len(original) + 5))
            self.assertEqual(path.read_bytes(), original)

    def test_raw_mode_accepts_legacy_text_file(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "legacy.bib"
            path.write_bytes(b"title = {Fluctuactions}\n")

            patch_file(
                path,
                [Operation(b"Fluctuactions", b"Fluctuations")],
                require_texmacs_header=False,
            )

            self.assertEqual(path.read_bytes(), b"title = {Fluctuations}\n")

    def test_rejects_non_byte_unicode(self) -> None:
        with self.assertRaisesRegex(PatchError, r"U\+03C0"):
            operations_from_json('[{"old": "pi", "new": "π"}]')

    def test_atomic_write_refuses_a_concurrent_change(self) -> None:
        with TemporaryDirectory() as directory:
            path = Path(directory) / "sample.tm"
            newer = b"<TeXmacs|2.1.4>\n<body|newer>\n"
            path.write_bytes(newer)

            with self.assertRaisesRegex(PatchError, "changed after the patch"):
                atomic_write(
                    path,
                    b"<TeXmacs|2.1.4>\n<body|patched>\n",
                    b"<TeXmacs|2.1.4>\n<body|older>\n",
                )

            self.assertEqual(path.read_bytes(), newer)


if __name__ == "__main__":
    unittest.main()
