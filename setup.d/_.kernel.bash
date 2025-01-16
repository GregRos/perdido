# configure BFQ I/O scheduler for all block devices
set -ex
echo CONFIGURING BFQ I/O SCHEDULER
modprobe bfq
echo bfq > /etc/modules-load.d/bfq.conf

echo 'ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"' > /etc/udev/rules.d/60-scheduler.rules
udevadm control --reload
udevadm trigger

echo CONFIGURE SYSCTL:
echo swappiness=15
echo fs.inotify.max_user_watches=204800
echo net.ipv4.ip_forward=1
echo '
vm.swappiness=15
net.ipv4.ip_forward=1
fs.inotify.max_user_watches=204800
' > /etc/sysctl.d/27-perdido.conf

sysctl -p
