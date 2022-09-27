import abc
from typing import Union

from script import InstallScript


class ScriptSpec(abc.ABC):
    @abc.abstractmethod
    def test(self, script: InstallScript):
        pass


class ScriptIdRangeSpec(ScriptSpec):
    def __init__(self, start: Union[int, None], end: Union[int, None]):
        self.start = start
        self.end = end

    def test(self, script: InstallScript):
        if self.start is not None and script.pos < self.start:
            return False
        if self.end is not None and script.pos > self.end:
            return False
        return True


class ScriptIdSpec(ScriptSpec):
    def __init__(self, index: int):
        self.index = index

    def test(self, script: InstallScript):
        return self.index == script.pos


class ScriptNameSpec(ScriptSpec):
    def __init__(self, name: str):
        self.name = name

    def test(self, script: InstallScript):
        return script.name.lower() == self.name.lower()


def parse_spec(text: str):
    if "-" in text:
        [before, after] = text.split("-")
        if not before or before.isdigit():
            return ScriptIdRangeSpec(int(before) if before else None, int(after) if after else None)
        else:
            return ScriptNameSpec(text)
    elif text.isdigit():
        return ScriptIdSpec(int(text))
    else:
        return ScriptNameSpec(text)


def parse_specs(text: list[str]):
    return [
        parse_spec(sub_tk.strip()) for tk in text for sub_tk in tk.split(",")
    ]
