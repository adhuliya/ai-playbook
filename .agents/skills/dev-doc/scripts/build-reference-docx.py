#!/usr/bin/env python3
"""Build templates/reference.docx with TableGrid (header fill) + SourceCode box."""
from __future__ import annotations

import subprocess
import tempfile
import zipfile
from copy import deepcopy
from pathlib import Path
import xml.etree.ElementTree as ET

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def q(tag: str) -> str:
    return f"{W}{tag}"


def ensure_table_grid(styles_root: ET.Element) -> None:
    for el in list(styles_root.findall(q("style"))):
        if el.get(q("styleId")) == "TableGrid":
            styles_root.remove(el)

    style = ET.Element(q("style"), {q("type"): "table", q("customStyle"): "1", q("styleId"): "TableGrid"})
    ET.SubElement(style, q("name"), {q("val"): "TableGrid"})
    ET.SubElement(style, q("basedOn"), {q("val"): "Table"})
    tbl_pr = ET.SubElement(style, q("tblPr"))
    borders = ET.SubElement(tbl_pr, q("tblBorders"))
    for edge in ("top", "left", "bottom", "right", "insideH", "insideV"):
        ET.SubElement(
            borders,
            q(edge),
            {q("val"): "single", q("sz"): "8", q("space"): "0", q("color"): "000000"},
        )
    first = ET.SubElement(style, q("tblStylePr"), {q("type"): "firstRow"})
    tc_pr = ET.SubElement(first, q("tcPr"))
    ET.SubElement(tc_pr, q("shd"), {q("val"): "clear", q("color"): "auto", q("fill"): "D6E3F0"})
    r_pr = ET.SubElement(first, q("rPr"))
    ET.SubElement(r_pr, q("b"))
    ET.SubElement(r_pr, q("bCs"))
    ET.SubElement(r_pr, q("color"), {q("val"): "0B1F3A"})
    styles_root.append(style)


def ensure_source_code(styles_root: ET.Element) -> None:
    # Remove any existing SourceCode so we own shading/borders
    for el in list(styles_root.findall(q("style"))):
        if el.get(q("styleId")) == "SourceCode":
            styles_root.remove(el)

    style = ET.Element(
        q("style"), {q("type"): "paragraph", q("customStyle"): "1", q("styleId"): "SourceCode"}
    )
    ET.SubElement(style, q("name"), {q("val"): "Source Code"})
    # Prefer Normal; fall back if absent
    based = "Normal"
    ids = {s.get(q("styleId")) for s in styles_root.findall(q("style"))}
    if "Normal" not in ids and "BodyText" in ids:
        based = "BodyText"
    ET.SubElement(style, q("basedOn"), {q("val"): based})
    p_pr = ET.SubElement(style, q("pPr"))
    ET.SubElement(p_pr, q("shd"), {q("val"): "clear", q("color"): "auto", q("fill"): "F3F5F8"})
    p_bdr = ET.SubElement(p_pr, q("pBdr"))
    for edge in ("top", "left", "bottom", "right"):
        ET.SubElement(
            p_bdr,
            q(edge),
            {q("val"): "single", q("sz"): "8", q("space"): "4", q("color"): "D5DBE3"},
        )
    ET.SubElement(p_pr, q("spacing"), {q("before"): "60", q("after"): "60"})
    r_pr = ET.SubElement(style, q("rPr"))
    ET.SubElement(
        r_pr,
        q("rFonts"),
        {q("ascii"): "Menlo", q("hAnsi"): "Menlo", q("cs"): "Menlo"},
    )
    ET.SubElement(r_pr, q("sz"), {q("val"): "18"})
    styles_root.append(style)


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    out = root / "templates" / "reference.docx"
    with tempfile.TemporaryDirectory() as td:
        td_path = Path(td)
        base = td_path / "base.docx"
        base.write_bytes(
            subprocess.check_output(["pandoc", "--print-default-data-file", "reference.docx"])
        )
        extract = td_path / "x"
        extract.mkdir()
        with zipfile.ZipFile(base, "r") as zf:
            zf.extractall(extract)

        styles_path = extract / "word" / "styles.xml"
        # Register default ns so write keeps prefix
        ET.register_namespace("w", W[1:-1])
        tree = ET.parse(styles_path)
        styles_root = tree.getroot()
        ensure_table_grid(styles_root)
        ensure_source_code(styles_root)
        tree.write(styles_path, encoding="utf-8", xml_declaration=True)

        # Validate via parse (default reference may include a self-closing w:style)
        n = len(ET.parse(styles_path).getroot().findall(q("style")))
        if n < 2:
            raise SystemExit(f"styles.xml parse produced too few styles: {n}")

        out.parent.mkdir(parents=True, exist_ok=True)
        if out.exists():
            out.unlink()
        with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in extract.rglob("*"):
                if path.is_file():
                    zf.write(path, path.relative_to(extract).as_posix())
        print(f"wrote {out}")


if __name__ == "__main__":
    main()
