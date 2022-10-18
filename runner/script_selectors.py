from __future__ import annotations


from typing import Iterable, Callable

from script import InstallScript


def range_selector(start: int | None, end: int | None) -> Callable[[InstallScript], bool]:
    def rule(script: InstallScript):
        if start is not None and script.pos < start:
            return False
        if end is not None and script.pos > end:
            return False
        return True

    return rule


def pos_selector(pos: int) -> Callable[[InstallScript], bool]:
    def rule(script: InstallScript):
        return script.pos == pos

    return rule


def name_selector(name: str) -> Callable[[InstallScript], bool]:
    def rule(script: InstallScript):
        return script.name.lower() == name.lower()

    return rule


def any_selector(selectors: Iterable[Callable[[InstallScript], bool]]) -> Callable[[InstallScript], bool]:
    def rule(script: InstallScript):
        return bool([1 for rule in selectors if rule(script)])

    return rule


def parse_selector(selector: str) -> Callable[[InstallScript], bool]:
    if "-" in selector:
        [before, after] = selector.split("-")
        # Either '-1' or '1-2':
        if not before or before.isdigit():
            return range_selector(int(before) if before else None, int(after) if after else None)
        else:
            # Must be a name with a '-' in it.
            return name_selector(selector)
    elif selector.isdigit():
        return pos_selector(int(selector))
    else:
        return name_selector(selector)


def parse_selectors(selectors: Iterable[str]) -> Callable[[InstallScript], bool]:
    return any_selector([parse_selector(s) for s in selectors])
