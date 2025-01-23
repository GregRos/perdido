from dataclasses import dataclass
from importlib.metadata import files
from os import path, stat_result
from pathlib import Path
from time import ctime
from typing import TypeVar, Union


@dataclass
class Stat:
    mtime: float
    size: int
    inode: int
    ctime: float

    def to_dict(self):
        return {
            "mtime": self.mtime,
            "size": self.size,
            "inode": self.inode,
        }

    @staticmethod
    def fromDict(data):
        stat = Stat(data["mtime"], data["size"], data["inode"], 0)

    @staticmethod
    def from_stat_result(stat: stat_result):
        return Stat(stat.st_mtime, stat.st_size, stat.st_ino, stat.st_ctime)


class FileInfo:
    path: Path
    stat: Stat

    def __init__(self, path: Path, stat: Union[Stat, None] = None) -> None:
        self.path = path
        self.stat = stat or Stat.from_stat_result(path.stat())

    def __hash__(self) -> int:
        return hash(self.path)

    def __eq__(self, o: object) -> bool:
        return isinstance(o, FileInfo) and self.path == o.path

    def to_dict(self):
        return {
            "path": str(self.path),
            "stat": self.stat.to_dict(),
        }

    @staticmethod
    def from_dict(data):
        return FileInfo(Path(data["path"]), Stat.fromDict(data["stat"]))


T = TypeVar("T")


class Library:
    _inode_to_file: dict[int, FileInfo]
    _files: dict[Path, FileInfo]
    name: str

    def __init__(self, name: str) -> None:
        self.name = name
        self._files = {}
        self._inode_to_file = {}

    def get_by_inode(self, inode: int, other: T) -> Union[FileInfo, T] | None:
        return self._inode_to_file.get(inode, other)

    def __contains__(self, inode_or_file: Union[FileInfo, int, Path, str]) -> bool:
        if isinstance(inode_or_file, FileInfo):
            return inode_or_file.path in self._files
        elif isinstance(inode_or_file, int):
            return inode_or_file in self._inode_to_file
        elif isinstance(inode_or_file, (Path, str)):
            return Path(inode_or_file) in self._files
        else:
            raise ValueError(f"Invalid type: {type(inode_or_file)}")

    def add(self, *files: FileInfo):
        self._files.update({file.path: file for file in files})
        for file in files:
            self._inode_to_file[file.stat.inode] = file

    def from_inode(self, inode: int) -> FileInfo:
        return self._inode_to_file[inode]

    def __iter__(self):
        return iter(self._files.values())

    def __len__(self) -> int:
        return len(self._files)

    def __repr__(self) -> str:
        return f"Library({self.name}, {len(self._files)} files)"

    def toDict(self):
        return {
            "name": self.name,
            "files": {str(file.path): file.to_dict() for file in self._files.values()},
        }

    @staticmethod
    def fromDict(data):
        lib = Library(data["name"])
        lib.add(*(FileInfo.from_dict(file) for file in data["files"].values()))
        return lib
