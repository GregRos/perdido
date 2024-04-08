
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
sudo curl -o /usr/share/fish/vendor_completions.d/docker-compose.fish https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/fish/docker-compose.fish
omf install bira
omf install bass
omf theme bira
echo "Update completions? [y/N]"
read -n 1 -l REPLY
if test "$REPLY" = y
    fish_update_completions
end
ln -sf ./secrets/profile.bash ~/.profile
echo "bass source /opt/perdido/secrets/factorio.bash
" > ~/.config/fish/conf.d/z.factorio.fish
