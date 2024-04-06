from concurrent.futures import ThreadPoolExecutor
from json import dumps
import logging
from pathlib import Path
from re import T
import sys
from time import sleep
from library import FileInfo, Library


logger = logging.getLogger("tree")


def tree(name: str, root: Path):
    library = Library(name)
    executor = ThreadPoolExecutor(max_workers=36)

    def scan_dir(dir: Path):
        for path in dir.iterdir():
            if path.is_dir():
                executor.submit(scan_dir, path)
            else:
                library.add(FileInfo(path))

    scan_dir(root)
    sleep(5)
    executor.shutdown(wait=True)
    return library
