from json import dumps, loads
from pathlib import Path
from typing import List
from tree import tree
from library import FileInfo, Library
from humanize import naturalsize

subdir = "shows"
main_lib = tree("main", Path(f"/data/library/"))
search_lib = tree("search", Path(f"/data/search-library/"))
downloads_lib = tree("downloads", Path(f"/data/downloads/done"))
newznab_lib = tree("usenet", Path(f"/data/usenet/done"))


all_non_main_libs = [search_lib, downloads_lib, newznab_lib]

for lib in all_non_main_libs:
    with open(f"{lib.name}.json", "w") as f:
        f.write(dumps(lib.toDict(), indent=2))

with open("main.json", "w") as f:
    f.write(dumps(main_lib.toDict(), indent=2))
all_inodes: dict[int, List[FileInfo]] = {}
for lib in all_non_main_libs:
    for file in lib:
        if file.stat.inode not in all_inodes:
            all_inodes[file.stat.inode] = []
        all_inodes[file.stat.inode].append(file)

stuffs = []
for inode, files in all_inodes.items():
    if inode not in main_lib:
        stuffs.append(files[0])

by_size = sorted(stuffs, key=lambda x: x.stat.size)
total_size = sum(file.stat.size for file in by_size if file.stat.size > 50 * 1024**2)
for file in by_size:
    file_name = file.path.name
    lib_name = file.path.parts[2]
    if (
        "movies" in str(file.path)
        or "shows" in str(file.path)
        or "done" in str(file.path)
    ):
        print("Deleting", file.path)
        file.path.unlink()
