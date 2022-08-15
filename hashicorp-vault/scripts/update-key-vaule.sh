#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "${CURRENT_DIR}"/env

export VAULT_ADDR=''
export VAULT_TOKEN=''

GROUP=''
PROJECT_NAME=''
ENVIROMENT='prod'

for ENVIROMENT in ${ENVIROMENT} ; do
    VAULT_SECRET_PATH="kv-${GROUP}-${PROJECT_NAME}/${ENVIROMENT}"
    vault kv put -format=json ${VAULT_SECRET_PATH} @${ENVIROMENT}-${PROJECT_NAME}.json
done
