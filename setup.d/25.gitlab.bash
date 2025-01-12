set -ex


export DEBIAN_FRONTEND=noninteractive

# check if we already have the repo
if [ ! -f /etc/apt/sources.list.d/gitlab_gitlab-ce.list ]; then
  apt-get install -y curl openssh-server ca-certificates perl
  curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
fi

if [ ! -f /usr/bin/gitlab-ctl ]; then
    echo TAKES A VERY LONG TIME
  apt-get -yy install gitlab-ce
fi

rm -rf /etc/gitlab/gitlab.rb || true
ln -sf "$(realpath ./config/gitlab/gitlab.rb)" /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure
gitlab-ctl restart nginx

docker pull gitlab/gitlab-runner:alpine3.19-v17.6.0
