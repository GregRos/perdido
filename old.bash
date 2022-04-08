#!/bin/bash
chsh -s /bin/bash
echo "export PS1='\[\e[0;38;5;82m\]\u\[\e[0;38;5;87m\]@\[\e[0;2;38;5;44m\]\H\[\e[0m\] in \[\e[0;1;38;5;43m\]\w\n\[\e[0;38;5;170m\]$ \[\e[0m\]'" >> ~/.bashrc
rtorrent_restart
mkdir -p filebot && cd filebot
curl -fsSL https://raw.githubusercontent.com/filebot/plugins/master/installer/tar-jdk8.sh | sh -xu
filebot -script fn:sysinfo
mkdir -p bin
ln -s $(realpath ./filebot.sh) ./bin/filebot 
myPath="$(realpath ./bin/)"
echo "export PATH=$myPath:\$PATH" >> ~/.bashrc

## Organize movies
myFormat='/home6/angr/our/movies/{ ~plex.derive{" {tmdb-$id}"}{" [$vf, $vc, $ac]"} }'
filebot -rename -r . --format "$myFormat" --db TheMovieDB -non-strict --mode interactive --action test 

## Organize series
myFormat='/home6/angr/our/series/{ ~plex.derive{" {tmdb-$id}"}{" [$vf, $vc, $ac]"} }'
filebot -rename -r . --format "$myFormat" --db TheMovieDB::Tv -non-strict --mode interactive --action test