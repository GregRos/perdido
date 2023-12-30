from argparse import ArgumentParser
from pathlib import Path

from consts import library_groups

cli = ArgumentParser(
    add_help=True,
    description="Delete media and all hardlinks from disk"
)

cli.add_argument(
    "media",
    nargs="+",
    type=Path
)
# --type movie
cli.add_argument(
    "--type",
    default="infer",
    choices=list(library_groups) + [
        "all",
        "infer"
    ],
    required=False,
    dest="in_type",
    help="Limits which library subfolders to search. Specify `all` to force all subfolders to be searched."
)

# --no-lib-check
cli.add_argument(
    "--no-lib-check",
    default=True,
    dest="lib_check",
    action="store_false",
)
