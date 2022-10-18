# This script opens ports for the applications in ufw. So far the ports have been closed.
# It doubles as a list of port assignments.
set -ex

echo OPENING STUCK PORTS

## STANDARD PORTS
ufw allow ssh http https

## FTP
# ufw allow ftp
# ufw allow "64000:64321/tcp" # (vsftpd)

## BITTORRENT PORTS (mysterious, better not touch)
ufw allow 45001

## SMB (Windows file sharing)
ufw allow 443

echo OPENING ASSIGNABLE PORTS

#




# Bit
ufw allow "64000:64321/tcp" # Used for

for arg in ssh http https 45001/tcp 443 7871 45001/udp "64000:64321/tcp"; do
  ufw allow $arg
done
sleep 1
ufw enable

