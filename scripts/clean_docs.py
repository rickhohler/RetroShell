#!/usr/bin/env python3
"""clean_docs.py - Bulk cleanup of markdown files in the RetroShell repository.

Features:
- Recursively find *.md files.
- Trim trailing whitespace.
- Collapse multiple blank lines to a single blank line.
- Ensure exactly one newline at EOF.
- Remove empty headings (e.g., "## \n").
- Remove placeholder sections containing TODO/FIXME.
- Run markdownlint (if installed) to auto‑fix common style issues.
- Print a short report of modified files.
"""
import pathlib, re, sys, subprocess

def clean_file(path: pathlib.Path) -> bool:
    original = path.read_text(encoding="utf-8")
    lines = original.splitlines()
    # Trim trailing whitespace
    lines = [line.rstrip() for line in lines]
    # Collapse multiple blank lines
    cleaned = []
    prev_blank = False
    for line in lines:
        if line.strip() == "":
            if not prev_blank:
                cleaned.append("")
            prev_blank = True
        else:
            cleaned.append(line)
            prev_blank = False
    # Remove empty headings (e.g., "## \n")
    def is_empty_heading(l):
        return re.match(r"^#{1,6}\s*$", l) is not None
    cleaned = [l for l in cleaned if not is_empty_heading(l)]
    # Remove placeholder sections containing TODO or FIXME (case‑insensitive)
    cleaned = [l for l in cleaned if not re.search(r"\bTODO\b|\bFIXME\b", l, re.I)]
    # Ensure single newline at EOF
    content = "\n".join(cleaned) + "\n"
    if content != original:
        path.write_text(content, encoding="utf-8")
        return True
    return False

def main():
    repo_root = pathlib.Path(__file__).resolve().parents[1]
    md_files = list(repo_root.rglob("*.md"))
    modified = []
    for f in md_files:
        try:
            if clean_file(f):
                modified.append(str(f))
        except Exception as e:
            print(f"Error processing {f}: {e}", file=sys.stderr)
    if modified:
        print("Modified files:")
        for m in modified:
            print(m)
    else:
        print("No changes needed.")
    # Run markdownlint if available
    try:
        subprocess.run(["markdownlint", "-c", "./.markdownlint.json", "-f", "quiet", "-r", "MD001,MD002,MD003,MD004,MD005,MD006,MD007,MD009,MD010,MD012,MD013,MD014,MD018,MD019,MD020,MD021,MD022,MD023,MD024,MD025,MD026,MD027,MD028,MD029,MD030,MD031,MD032,MD033,MD034,MD035,MD036,MD037,MD038,MD039,MD040,MD041,MD042,MD043,MD044,MD045,MD046,MD047,MD048,MD049,MD050,MD051,MD052,MD053,MD054,MD055,MD056,MD057,MD058,MD059,MD060,MD061,MD062,MD063,MD064,MD065,MD066,MD067,MD068,MD069,MD070,MD071,MD072,MD073,MD074,MD075,MD076,MD077,MD078,MD079,MD080,MD081,MD082,MD083,MD084,MD085,MD086,MD087,MD088,MD089,MD090,MD091,MD092,MD093,MD094,MD095,MD096,MD097,MD098,MD099,MD100,MD101,MD102,MD103,MD104,MD105,MD106,MD107,MD108,MD109,MD110,MD111,MD112,MD113,MD114,MD115,MD116,MD117,MD118,MD119,MD120,MD121,MD122,MD123,MD124,MD125,MD126,MD127,MD128,MD129,MD130,MD131,MD132,MD133,MD134,MD135,MD136,MD137,MD138,MD139,MD140,MD141,MD142,MD143,MD144,MD145,MD146,MD147,MD148,MD149,MD150,MD151,MD152,MD153,MD154,MD155,MD156,MD157,MD158,MD159,MD160,MD161,MD162,MD163,MD164,MD165,MD166,MD167,MD168,MD169,MD170,MD171,MD172,MD173,MD174,MD175,MD176,MD177,MD178,MD179,MD180,MD181,MD182,MD183,MD184,MD185,MD186,MD187,MD188,MD189,MD190,MD191,MD192,MD193,MD194,MD195,MD196,MD197,MD198,MD199,MD200,MD201,MD202,MD203,MD204,MD205,MD206,MD207,MD208,MD209,MD210,MD211,MD212,MD213,MD214,MD215,MD216,MD217,MD218,MD219,MD220,MD221,MD222,MD223,MD224,MD225,MD226,MD227,MD228,MD229,MD230,MD231,MD232,MD233,MD234,MD235,MD236,MD237,MD238,MD239,MD240,MD241,MD242,MD243,MD244,MD245,MD246,MD247,MD248,MD249,MD250,MD251,MD252,MD253,MD254,MD255,MD256,MD257,MD258,MD259,MD260,MD261,MD262,MD263,MD264,MD265,MD266,MD267,MD268,MD269,MD270,MD271,MD272,MD273,MD274,MD275,MD276,MD277,MD278,MD279,MD280,MD281,MD282,MD283,MD284,MD285,MD286,MD287,MD288,MD289,MD290,MD291,MD292,MD293,MD294,MD295,MD296,MD297,MD298,MD299,MD300"], cwd=repo_root, check=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        pass

if __name__ == "__main__":
    main()
