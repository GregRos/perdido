# configure BFQ I/O scheduler for all block devices
set -ex
echo CONFIGURING BFQ I/O SCHEDULER
modprobe bfq
echo bfq > /etc/modules-load.d/bfq.conf

echo 'ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"' > /etc/udev/rules.d/60-scheduler.rules
udevadm control --reload
udevadm trigger

