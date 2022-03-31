sudo apt update
#sudo apt -y full-upgrade
#   Step 2: Install kubelet, kubeadm and kubectl
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   #   Then install required packages.

sudo apt update
sudo apt -y install apt-utils vim git curl wget   kubernetes-cni kubeadm kubectl kubelet
#sudo apt-mark hold kubelet kubeadm kubectl
#  Confirm installation by checking the version of kubectl.

#   $ kubectl version --client && kubeadm version
#   Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"linux/amd64"}
#   kubeadm version: &version.Info{ Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:57:37Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"linux/amd64" }
#   Step 3: Disable Swap
#  Turn off swap.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system


#sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io
#sudo apt install -y containerd.io docker-ce docker-ce-cli

  # Create required directories
#sudo mkdir -p /etc/systemd/system/docker.service.d

  # Create daemon json config file
#sudo cat /etc/docker/daemon.json << EOF
#{
#  "exec-opts": ["native.cgroupdriver=systemd"],
#  "log-driver": "json-file",
#  "log-opts": {
#    "max-size": "100m"
#  },
#  "storage-driver": "overlay2"
#}
#EOF

sudo mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status  containerd


# Start and enable Services
#sudo systemctl daemon-reload
#sudo systemctl restart docker
#sudo systemctl enable docker

[ -f /var/run/reboot-required ] && sudo reboot -f


cat > /user/root/initialise-master.sh << EOF
echo " Check if br_netfilter is enabled "
lsmod | grep br_netfilter
sudo systemctl enable kubelet

echo "We now want to initialize the machine that will run the control plane components which includes etcd (the cluster database) and the API Server."

echo "Pull container images:"

sudo kubeadm config images pull
#[config/images] Pulled k8s.gcr.io/kube-apiserver:v1.23.5
#[config/images] Pulled k8s.gcr.io/kube-controller-manager:v1.23.5
#[config/images] Pulled k8s.gcr.io/kube-scheduler:v1.23.5
#[config/images] Pulled k8s.gcr.io/kube-proxy:v1.23.5
#[config/images] Pulled k8s.gcr.io/pause:3.6
#[config/images] Pulled k8s.gcr.io/etcd:3.5.1-0
#[config/images] Pulled k8s.gcr.io/coredns/coredns:v1.8.6

echo "maybe required  : sudo kubeadm config images pull --cri-socket /var/run/docker.sock"

EOF

EOF
