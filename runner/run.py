#!/usr/bin/python3
import argparse
from pathlib import Path
from subprocess import Popen, PIPE

from script_spec import parse_specs
from script import InstallScript


def create_cli():
    root_parser = argparse.ArgumentParser(description="Perdido setup script runner")
    subparsers = root_parser.add_subparsers(title="command", required=True, dest="command")
    run = subparsers.add_parser("run", help="run one or more installation scripts")
    run.add_argument("rules", nargs="+", help="one or more installation script names, numbers, or ranges")

    subparsers.add_parser("install", help="run all installation scripts in order")

    subparsers.add_parser("list", help="list installation scripts")
    test = subparsers.add_parser("test", help="test a rule spec")
    test.add_argument("rules", nargs="+", help="one or more installation script names, numbers, or ranges")
    return root_parser


root_dir = Path(__file__).parent.parent
scripts = [
    InstallScript(curScript) for curScript in Path(__file__).parent.parent.glob("setup.d/*.bash")
]
scripts.sort(key=lambda x: x.pos)

cli = create_cli()
result = cli.parse_args()
command = result.command
if command == "list":
    print("\n".join((str(x) for x in scripts)))
elif command == "install":
    for script in scripts:
        script.run()
else:
    rules = parse_specs(result.rules)
    matched_scripts = [
        script for script in scripts if [0 for rule in rules if rule.test(script)]
    ]
    if command == "test":
        print("\n".join((str(x) for x in matched_scripts)))
    elif command == "run":
        for script in matched_scripts:
            script.run()

