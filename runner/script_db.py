from os import PathLike
from pathlib import Path
from script import InstallScript


from typing import Callable, Iterable


class ScriptDb:
    _by_name = dict[str, InstallScript]()
    _by_pos = dict[int, InstallScript]()

    def __init__(self, scripts: Iterable[InstallScript]):
        self.add(*scripts)

    def __iter__(self):
        ordered_scripts = sorted(self._by_name.values(), key=lambda x: x.pos_str)
        self.__hash__()
        for cur_script in ordered_scripts:
            yield cur_script

    def add_one_pos(self, script: InstallScript):
        pos = script.pos
        if pos is None:
            return
        existing = self._by_pos.get(pos)
        if existing:
            raise Exception(
                f"Tried to register script {script}, but a script with the same pos exists: {existing}"
            )
        self._by_pos[pos] = script

    def add_one_name(self, script: InstallScript):
        name = script.name
        existing = self._by_name.get(name)
        if existing:
            raise Exception(
                f"Tried to register script {script}, but a script with the same name exists: {existing}"
            )
        self._by_name[name] = script

    def add_one(self, script: InstallScript):
        self.add_one_pos(script)
        self.add_one_name(script)

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
