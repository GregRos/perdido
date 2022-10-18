import sys
from os import PathLike
from pathlib import Path
from subprocess import Popen, PIPE, STDOUT
from threading import Thread
from typing import IO, Iterable, Callable


class InstallScript:
    pos: int
    name: str
    path: Path

    def __init__(self, path: Path):
        name = path.stem
        [pos, name] = name.split(".")
        self.pos = int(pos)
        self.name = name
        self.path = path

    def __str__(self):
        return f"{str(self.pos).zfill(2)} {self.name}"

    def run(self):
        def _read(stream: IO):
            for line in stream:
                sys.stdout.write(f"[{str(self.pos).zfill(2)} {self.name.upper()}] {line.strip()}\n")

        p = Popen(
            ["/bin/bash", str(self.path)],
            stdout=PIPE,
            stderr=STDOUT,
            shell=False,
            encoding="utf-8"
        )
        r_stdout = Thread(
            target=lambda: _read(
                p.stdout
            )
        )
        r_stdout.start()
        p.wait()
        if p.returncode > 0:
            raise ScriptFailedError(self)


class ScriptFailedError(Exception):
    def __init__(self, script: InstallScript):
        super().__init__(f"Script")
        self.script = script


class ScriptDb:
    _by_name = dict[str, InstallScript]()
    _by_pos = dict[int, InstallScript]()

    def __init__(self, scripts: Iterable[InstallScript]):
        self.add(*scripts)

    def __iter__(self):
        positions = sorted(self._by_pos.keys())
        for cur_pos in positions:
            yield self._by_pos[cur_pos]

    def add_one(self, script: InstallScript):
        existing_pos = self._by_pos.get(script.pos)
        existing_name = self._by_name.get(script.name)

        if existing_name:
            raise Exception(f"Tried to register script {script}, but a script with the same name exists: {existing_name}")
        if existing_pos:
            raise Exception(f"Tried to register script {script}, but a script with the same pos exists: {existing_pos}")

        self._by_pos[script.pos] = script
        self._by_name[script.name] = script

    def get_by_pos(self, pos: int):
        return self._by_pos[pos]

    def get_by_name(self, name: str):
        return self._by_name[name]

    def find_all(self, predicate: Callable[[InstallScript], bool]):
        return filter(predicate, self)

    def add(self, *scripts: InstallScript):
        for script in scripts:
            self.add_one(script)
        return self


class PerdidoScriptDb(ScriptDb):
    def __init__(self, root: PathLike):
        root = Path(root)
        super().__init__(
            [InstallScript(script) for script in root.glob("setup.d/*.bash")]
        )
        self._root = root
