# Download and install fnm:
set -ex

echo INSTALLING nodejs 22.x from NodeSource

dir=/tmp/install_node
mkdir -p $dir
cd $dir
rm -f nodesource_setup.sh
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
node -v

echo NODE OK
echo INSTALLING yarn VIA corepack
corepack enable
corepack install --global yarn@stable
