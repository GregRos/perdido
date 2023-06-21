#!/usr/bin/env bash
set -ex

restic forget --tag minecraft-world \
              --keep-last 5 \
              --keep-hourly-within 1d \
              --keep-daily-within 7d \
              --keep-weekly-within 30d \
              --keep-monthly-within 1y \
              --keep-yearly-within 100y

restic forget --tag minecraft \
              --keep-last 5 \
              --keep-hourly-within 4h \
              --keep-daily-within 4d \
              --keep-weekly-within 14d \
              --keep-monthly-within 4m \
              --keep-yearly-within 100y

restic forget --tag factorio \
              --keep-last 5 \
              --keep-hourly-within 1d \
              --keep-daily-within 7d \
              --keep-weekly-within 30d \
              --keep-monthly-within 1y \
              --keep-yearly-within 100y

restic forget --tag factorio-world \
              --keep-last 5 \
              --keep-hourly-within 1d \
              --keep-daily-within 7d \
              --keep-weekly-within 30d \
              --keep-monthly-within 1y \
              --keep-yearly-within 100y
