#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "${CURRENT_DIR}"/env

export VAULT_ADDR=''
export VAULT_TOKEN=''

project_name=''
env='dev'
list_app='a b c'

for env in ${env} ; do
    for app in ${list_app} ; do
        vault_secret_path="${project_name}-kv/${env}/${app}"
        vault kv get -format=json ${vault_secret_path} | jq -r .data.data > ${CURRENT_DIR}/${env}-${project_name}-${app}.json
        jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' ${CURRENT_DIR}/${env}-${project_name}-${app}.json > ${CURRENT_DIR}/env/.${env}_${project_name}_${app}_env
    done
done
