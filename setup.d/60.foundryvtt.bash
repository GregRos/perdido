set -ex

mkdir -p /data/foundryvtt
cd ./config/foundryvtt
docker compose down || true
docker compose up -d
while [ $SECONDS -lt 180 ]; do  # Check for up to 3 minutes (180 seconds)
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "foundryvtt-foundry-1")

    if [ "$HEALTH_STATUS" == "healthy" ]; then
        echo "Container is healthy!"
        cp "$(realpath ./backup.cronjob)" /etc/cron.d/backup-foundryvtt
        chown root:root /etc/cron.d/backup-foundryvtt
        exit 0
    fi

    echo "Waiting for container to become healthy..."
    sleep 5  # Poll every 5 seconds
done

echo "Timed out after 3 minutes. Container is not healthy."
exit 1


