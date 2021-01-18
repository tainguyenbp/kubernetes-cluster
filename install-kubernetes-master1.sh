#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR"/env-hosts.sh

echo "$IP_K8S_MASTER	$NAME_K8S_MASTER" >> /etc/hosts
echo "$IP_K8S_NODE_1	$NAME_K8S_NODE_1" >> /etc/hosts
echo "$IP_K8S_NODE_2	$NAME_K8S_NODE_2" >> /etc/hosts

