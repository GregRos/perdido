#!/bin/bash

set -ex

final_path="$1"
job_status="$7"
# if job status is not 0, then the download failed
if [[ "$job_status" != "0" ]]; then
  echo "Download failed, not moving."
  exit 0
fi
/opt/perdido/commands/sweeper "$final_path"
