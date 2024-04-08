# This script opens ports for the applications in ufw. So far the ports have been closed.
# It doubles as a list of port assignments.
set -ex

echo OPENING STUCK PORTS

## STANDARD PORTS
for arg in 22 80 443 7871 45001 "64000:64321/tcp"; do
  ufw allow $arg
done


sleep 1
ufw enable

