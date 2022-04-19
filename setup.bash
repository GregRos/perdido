#!/bin/bash
echo --- BASIC PACKAGES ---

export DEBIAN_FRONTEND=noninteractive

echo Starting file execution

min_file="$1"
for file in ./setup.d/*.bash; do
  if [ -n "$min_file" ]; then
    script_num="$(echo $file | grep -oh '^\d+')"
    if (( script_num < min_file )); then
      continue
    fi
  fi
  # guaranteed to be alphabetical, which is why we do the above...
  if ! bash "$file"; then
    echo Error executing $file
    exit 3
  fi
done

echo --- ALL DONE ---
