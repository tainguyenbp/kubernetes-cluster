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
