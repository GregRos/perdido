#!/usr/bin/fish
cd /home/gr
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bira
omf theme bira
fish_update_completions
