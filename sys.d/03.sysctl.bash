swappiness=15
watches=204800

echo "
vm.swappiness=$swappiness
fs.inotify.max_user_watches=$watches

" > /etc/sysctl.d/31-perdido.conf

sysctl -p
