#!/usr/bin/env bash
set -ex
function do_on_complete {
  echo "Torrent download completed: $TR_TORRENT_NAME"
  old_torrent_path="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
  if [ -f "$old_torrent_path" ]; then
    echo "Torrent is a file, moving to directory"
      dir_name="${TR_TORRENT_NAME%.*}"
      mkdir -p "$TR_TORRENT_DIR/$dir_name"
      torrent_path="$TR_TORRENT_DIR/$dir_name"
      mv "$torrent_path" "$TR_TORRENT_DIR/$dir_name"
      echo "Torrent moved to $torrent_path"
  elif [ -d "$old_torrent_path" ]; then
      echo "Torrent is a directory."
      torrent_path="$old_torrent_path"
  else
      echo "ERROR: Torrent is not a file or directory."
      exit 1
  fi
  /opt/perdido/commands/sweeper "$torrent_path"
}
do_on_complete >> /var/log/transmission/on_complete.log
echo "
" >> /var/log/transmission/on_complete.log
