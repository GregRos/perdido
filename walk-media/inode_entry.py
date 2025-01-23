from pathlib import Path


class INodeEntry:
    def __init__(self, inode: int, lib_path: Path, dl_path: Path) -> None:
        self.inode = inode
        self.lib_path = lib_path
        self.dl_path = dl_path

    def to_dict(self):
        return {
            "inode": self.inode,
            "lib_path": str(self.lib_path),
            "dl_path": str(self.dl_path),
        }
