#!/bin/bash

set -ex

env > ~/on_complete.env
"$@" > ~/on_complete.log 2>&1
