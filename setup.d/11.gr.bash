## Setup SSH keys for gr
echo --- SETTING UP GR ---

exec > >(trap "" INT TERM; sed 's/^/[USER GR] /')
set -ex

echo SETTING UP SSH
SSH=/home/gr/.ssh
mkdir -p $SSH/authorized_keys.d
chmod 0700 $SSH
cp -f data/gr.pub $SSH/authorized_keys.d/
cat $SSH/authorized_keys.d/* > /home/gr/.ssh/authorized_keys
chown -R gr:gr $SSH

echo SETTING UP FISH SHELL
usermod --shell /usr/bin/fish gr
sudo -u gr fish setup.d/gr.fish

echo --- DONE ---
