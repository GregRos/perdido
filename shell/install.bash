#!/usr/bin/env bash
set -ex
ln -sf "$(realpath shell/fish_greeting.fish)" $HOME/.config/fish/functions/
ln -sf "$(realpath shell/pd-tools.fish)" $HOME/.config/fish/conf.d/
ln -sf "$(realpath shell/env.fish)" $HOME/.config/fish/conf.d/
