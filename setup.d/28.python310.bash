## Setup SSH keys for gr

set -ex
# Sweeper is written in Python 3.10. I could rewrite it but I like some of the
# typing features they added, so I'm going to compile Python 3.10 instead.
echo DOWNLOADING SOURCE
sudo apt-get install sabnzbdplus libffi-dev libbz2-dev

wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
tar xzf Python-3.10.4.tgz
cd Python-3.10.4

echo RUNNING CONFIGURE
./configure --enable-optimizations --with-system-ffi

echo INSTALL and BUILD

make altinstall

echo TESTING
python3.10 -V
pip3.10 -V
