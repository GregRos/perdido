## Setup SSH keys for gr

echo --- SETTING UP GR ---
exec > >(trap "" INT TERM; sed 's/^/[USER GR] /')
exec 2> >(trap "" INT TERM; sed 's/^/[USER GR] /' >&2)

echo SETTING UP SSH KEYS
SSH=/home/gr/.ssh
mkdir -p $SSH
chmod 0700 $SSH
cat data/gr.pub >> $SSH/authorized_keys
chown -R gr:gr $SSH

echo SETTING UP FISH SHELL
chsh -u gr -s /usr/bin/fish
sudo -u gr -c 'fish gr.fish'

echo --- DONE ---
