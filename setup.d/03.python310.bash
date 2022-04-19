## Setup SSH keys for gr
echo --- INSTALL PYTHON. 3.10 ---

exec > >(trap "" INT TERM; sed 's/^/[03 PYTHON3.10] /')
set -ex

echo DOWNLOADING SOURCE

wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
tar xzf Python-3.10.4.tgz

echo CONFIGURE
./configure --enable-optimizations

echo INSTALLING
make altinstall

echo CHECKING
python3.10 -V
pip3.10 -V
