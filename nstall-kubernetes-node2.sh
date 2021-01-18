#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR"/env-hosts.sh

echo "$IP_K8S_MASTER	$NAME_K8S_MASTER" >> "$PATH_FILE_HOST_NODE"
echo "$IP_K8S_NODE_1	$NAME_K8S_NODE_1" >> "$PATH_FILE_HOST_NODE"
echo "$IP_K8S_NODE_2	$NAME_K8S_NODE_2" >> "$PATH_FILE_HOST_NODE"

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

sed -i '/swap/d' /etc/fstab
swapoff -a

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce-18.06.3.ce-3.el7 docker-ce-cli-18.06.3.ce-3.el7 containerd.io

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet-1.18.14 kubeadm-1.18.14 kubectl-1.18.14

systemctl start docker && systemctl enable docker
systemctl start kubelet && systemctl enable kubelet
