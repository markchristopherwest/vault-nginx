#!/bin/bash

set -e

sleep 5

echo "Hello I am the helper-agent.sh and my purpose in life is to setup Vault agent to get transit keys for my app"


apt-get update
apt-get install -y jq wget gpg libcap2-bin

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list

apt-get update
apt-get install -y vault

setcap cap_ipc_lock= /usr/bin/vault

which vault

export VAULT_ADDR="http://host.docker.internal:8200"
export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=$(cat /sensitive/vault.txt | grep '^Initial' | awk '{print $4}')
# Start Vault Agent again with additional configuration.
vault agent -config=/sensitive/agent-config.hcl 

