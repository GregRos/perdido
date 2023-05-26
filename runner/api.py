
from typing import Protocol, Callable

from script import ScriptDb, InstallScript


class Command(Protocol):
    command: str
    rule: Callable[[InstallScript], bool]


class Api:
    scripts: ScriptDb

    def __init__(self, script_db: ScriptDb):
        self.scripts = script_db

    def _chown(self):
        self.scripts.get_by_name("fix-permissions").run()

    def _match(self, rule: Callable[[InstallScript], bool]):
        scripts = [script for script in self.scripts.find_all(rule)]
        if not scripts:
            print("MATCHED 0 SCRIPTS")
            exit(1)
        return scripts

    def _print(self, rule: Callable[[InstallScript], bool]):
        for script in self._match(rule):
            print(str(script))

    def _run(self, rule: Callable[[InstallScript], bool]):
        for script in self._match(rule):
            script.run()

    def invoke(self, obj: Command):
        if obj.command == "run":
            return self._run(obj.rule)
        elif obj.command == "install":
            return self._run(lambda x: True)
        elif obj.command == "test":
            return self._print(obj.rule)
        elif obj.command == "list":
            return self._print(lambda x: True)
        elif obj.command == "chown":
            return self._chown()
        else:
            raise Exception(f"Unknown command {obj.command}.")
