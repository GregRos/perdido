from json import dumps, loads
from pathlib import Path
from typing import List
from tree import tree
from library import FileInfo, Library
from humanize import naturalsize
from inode_entry import INodeEntry

main_lib = tree("main", Path(f"/data/library/"))
# search_lib = tree("search", Path(f"/data/search-library/"))
downloads_lib = tree("downloads", Path(f"/data/downloads/done"))
newznab_lib = tree("usenet", Path(f"/data/usenet/done"))


dl_libs = [downloads_lib, newznab_lib]


entries = []
for file in main_lib:
    for lib in [downloads_lib, newznab_lib]:
        inode = file.stat.inode
        if inode in lib:

            entries.append(
                INodeEntry(
                    inode, main_lib.from_inode(inode).path, lib.from_inode(inode).path
                )
            )

with open("dl_history.json", "w") as f:
    f.write(dumps([entry.to_dict() for entry in entries], indent=2))
