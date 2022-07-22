## Setup SSH keys for gr

set -ex

echo DOWNLOADING SOURCE

wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
tar xzf Python-3.10.4.tgz
cd Python-3.10.4

echo RUNNING CONFIGURE
./configure --enable-optimizations

echo INSTALL and BUILD

make altinstall

echo TESTING
python3.10 -V
pip3.10 -V
