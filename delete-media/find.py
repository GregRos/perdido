import os
import re
from collections import defaultdict
from pathlib import Path
from typing import List

from bidict import bidict

from consts import library_groups


def _get_paths(media: Path):
    if media.is_file():
        return [media]
    else:
        return [path.absolute() for path in media.rglob("*") if path.is_file()]


def get_child_file_inodes(media: Path):
    paths = _get_paths(media)
    return bidict({path: path.stat().st_ino for path in paths})


def _get_find_cmd(inodes: set[int], parents: set[Path]):
    if not parents:
        return ""
    if not inodes:
        raise Exception("No inodes provided")

    def get_inum(inode):
        return f"-inum {inode}"

    def get_inums(inodes):
        return " -o ".join([get_inum(inode) for inode in inodes])

    conditions = get_inums(inodes)
    format=" -printf '%i %p\\n'"
    return f"find {' '.join([str(parent) for parent in parents])} \\( {conditions} \\) {format}"


def _find_by_inodes(inodes: set[int], parents: set[Path]):
    results_dict = defaultdict(
        set
    )
    cmd = _get_find_cmd(inodes, parents)
    print(f"Running: {cmd}")
    results = os.popen(cmd).read().splitlines()
    for line in results:
        print(line)
        inode, path = line.split(" ", 1)
        results_dict[int(inode)] |= {Path(path)}

    return dict(results_dict)


def find_samefiles(medias: set[Path], targets: set[Path]):
    all_inodes = [get_child_file_inodes(media) for media in medias]
    inodes_bi = bidict()
    for inodes in all_inodes:
        inodes_bi.update(inodes)
    results = _find_by_inodes(set(inodes_bi.values()), targets)
    samefiles = [
        SameFile(inodes_bi.inverse[inode], inode, results) for inode, results in results.items()
    ]

    return samefiles


class SameFile:
    source: Path
    inode: int
    paths: set[Path]

    def __init__(self, source: Path, inode: int, paths: set[Path]):
        self.source = source
        self.inode = inode
        self.paths = paths

    def __str__(self):
        listings = "\n".join([f"- {path}" for path in self.all()])
        return f"""
{self.inode} {self.source}
{listings}        
        """

    def all(self):
        return {self.source} | self.paths
