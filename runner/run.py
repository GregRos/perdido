#!/usr/bin/python3
from pathlib import Path

from api import Api
from cli import cli
from script_db import PerdidoScriptDb

script_db = PerdidoScriptDb(Path(__file__).parents[1])
api = Api(script_db)

command = cli.parse()
api.invoke(command)
