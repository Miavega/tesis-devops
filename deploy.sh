# Actualizar SO
yum update -y
yum upgrade -y

# Instalar htop para monitoreo de recursos
yum -y install epel-release
yum install htop

# Instalar GIT
yum install -y git

# Instalar Docker (https://rancher.com/docs/k3s/latest/en/advanced/#using-docker-as-the-container-runtime)
curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -aG docker ${USER} # Reemplazar por k3s

# Instalar K3S (https://rancher.com/docs/k3s/latest/en/quick-start/ || https://rancher.com/docs/k3s/latest/en/advanced/#using-docker-as-the-container-runtime)
curl -sfL https://get.k3s.io | sh -s - --docker

# Añadir volumen de persistencia (https://github.com/rancher/local-path-provisioner/blob/master/README.md#usage)
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

# Si falla intentar (https://stackoverflow.com/questions/52619828/kubernetes-no-route-to-host)
iptables --flush
iptables -tnat --flush
systemctl stop firewalld
systemctl disable firewalld
systemctl restart docker

sudo iptables -D  INPUT -j REJECT --reject-with icmp-host-prohibited
sudo iptables -D  FORWARD -j REJECT --reject-with icmp-host-prohibited

# Instalar portainer (https://documentation.portainer.io/v2.0/deploy/ceinstallk8s/) LOADBALANCER
kubectl apply -n portainer -f https://raw.githubusercontent.com/portainer/k8s/master/deploy/manifests/portainer/portainer-lb.yaml

# Crear namespaces
kubectl create namespace devops

# Instalar Jenkins
cd /home/{USER}/Miavega/tesis-devops/jenkins
sh jenkins.sh