import argparse
from typing import Iterable, Sequence, Union

from api import Command
from script_selectors import parse_selectors


class Cli:
    def __init__(self):
        root_parser = argparse.ArgumentParser(description="Perdido setup script runner")
        subparsers = root_parser.add_subparsers(
            title="command", required=True, dest="command"
        )

        run = subparsers.add_parser(
            "run",
            help="run one or more installation scripts",
        )
        run.add_argument(
            "rule",
            nargs="+",
            help="one or more installation script names, numbers, or ranges",
        )

        subparsers.add_parser("install", help="run all installation scripts in order")

        subparsers.add_parser("list", help="list installation scripts")
        printing = subparsers.add_parser("print", help="print installation scripts")
        printing.add_argument(
            "rule",
            nargs="+",
            help="one or more installation script names, numbers, or ranges",
        )
        test = subparsers.add_parser("test", help="test a rule spec")
        test.add_argument(
            "rule",
            nargs="+",
            help="one or more installation script names, numbers, or ranges",
        )

        chown = subparsers.add_parser("chown", help="fix permissions")

        self._parser = root_parser

    def parse(self, args: Union[Sequence[str], None] = None) -> Command:
        args_result = self._parser.parse_args(args)
        if hasattr(args_result, "rule"):
            args_result.rule = parse_selectors(args_result.rule)
        return args_result  # type: ignore


cli = Cli()
