set -ex

snap install microk8s --classic 
snap refresh
microk8s enable 
usermod -a -G microk8s gr
newgrp microk8s
cp -f ./config/microk8s/csr.conf.template /var/snap/microk8s/current/certs/csr.conf.template
microk8s refresh-certs --cert fserver.crt