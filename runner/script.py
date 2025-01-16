import sys
from pathlib import Path
from subprocess import Popen, PIPE, STDOUT
from threading import Thread
from typing import IO, Iterable, Union


class InstallScript:
    pos: Union[int, None]
    name: str
    path: Path

    @property
    def pos_str(self):
        return "_" if self.pos is None else str(self.pos)

    def _read_lines(self):
        with self.path.open() as file:
            return file.readlines()

    def pretty_print(self):
        return pretty_print_lines(self._read_lines())

    def __init__(self, path: Path):
        name = path.stem
        [pos, name] = name.split(".")
        # is pos a number?
        if pos.isdigit():
            self.pos = int(pos)
        elif pos == "_":
            # special case for scripts without a position
            # that are executed manually
            self.pos = None
        else:
            raise Exception(f"Invalid script position component: {name}")
        self.name = name
        self.path = path

    def __str__(self):
        return f"{str(self.pos).zfill(2)} {self.name}"

    def run(self):
        def _read(stream: IO):
            for line in stream:
                sys.stdout.write(
                    f"[{str(self.pos_str).zfill(2)} {self.name.upper()}] {line.strip()}\n"
                )

        p = Popen(
            ["/bin/bash", str(self.path)],
            stdout=PIPE,
            stderr=STDOUT,
            shell=False,
            encoding="utf-8",
        )
        stdout = p.stdout
        if not stdout:
            raise Exception(f"Failed to open {self.path}")
        r_stdout = Thread(target=lambda: _read(stdout))
        r_stdout.start()
        p.wait()
        if p.returncode > 0:
            raise ScriptFailedError(self)


class ScriptFailedError(Exception):
    def __init__(self, script: InstallScript):
        super().__init__(f"Script")
        self.script = script


def pretty_print_lines(lines: Iterable[str]):
    # NNN | Line
    lines = [f"{(i + 1):>3} | {line}" for i, line in enumerate(lines)]
    return "".join(lines)
