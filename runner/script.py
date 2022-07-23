import sys
from pathlib import Path
from subprocess import Popen, PIPE, STDOUT
from threading import Thread
from typing import Callable, IO


class InstallScript:
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
