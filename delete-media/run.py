import re
from pathlib import Path

from find import find_samefiles
from cli import cli
from consts import library_groups

library_roots = [Path("/data/library"), Path("/data/search-library")]


def infer_type(media: Path):
    media_groups = rf"/data/(library|search-library)/({'|'.join(library_groups)})s?/"
    matched = re.search(media_groups, str(media))
    if not matched:
        print(f"Could not infer type of {media}. Using 'all'.")
        return "all"
    type = matched.group(2)
    return type


def get_library_roots(media: Path):
    lib_roots = {root for root in library_roots if not media.is_relative_to(root)}
    return lib_roots


args = cli.parse_args()
medias = set(args.media)
for media in medias:
    if media.is_dir() and not list(media.iterdir()):
        media.rmdir()
        print(f"Removed empty directory {media}")
        exit(0)

in_type = args.in_type
types = {in_type} if in_type != "infer" else {infer_type(media) for media in medias}
roots = {root for media in medias for root in get_library_roots(media)}
types = library_groups if "all" in types else types
targets = {root / f"{type}s" for root in roots for type in types} | {
    "/data/downloads/done"
}
samefiles = find_samefiles(medias, targets)
print(f"Found {len(samefiles)} samefiles")
for samefile in samefiles:
    print(samefile, "\n")


for samefile in find_samefiles(medias, targets):
    for file in samefile.all():
        parent = file.parent
        file.unlink()
        # get rid of empty directories
        if not list(parent.iterdir()):
            parent.rmdir()
