#!/bin/bash

set -eu
set -o pipefail

# Example: OPENSTACK_CONFIG_DOCKER_IMAGE=config-prebuild .automation/run-local.sh .automation/cd/apply.sh -p ansible/um6p-project.yml -- --env OPENSTACK_CONFIG_VAULT_PASSWORD=$(< ~/.kayobe-vault-pass) --env OPENSTACK_CONFIG_OPENRC="$(< ~/will/openrc-um6p-config)"

PARENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$PARENT/.."

source "${PARENT}/functions"

function config_extras {
    export OPENSTACK_CONFIG_DOCKER_IMAGE="${OPENSTACK_CONFIG_DOCKER_IMAGE:-centos:8}"
}


function main {
    config_extras
    RELATIVE_PATH=$(realpath --relative-to="$REPO_ROOT" "$1")
    SCRIPT_ARGS=()
    shift
    echo "CI script: $RELATIVE_PATH"
    # Arguments before -- are passed to the script, arguments that are listed after are passed to docker
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            --)
                shift
                break
            ;;
        *)
        SCRIPT_ARGS+=("$1")
        shift
        ;;
    esac
    done
    #echo "Script args: ${SCRIPT_ARGS[@]}"
    # WARNING: printing docker args will leak your environment file
    #echo "docker args: $@"
    docker run --rm -it "$@" -v $REPO_ROOT:/src "$OPENSTACK_CONFIG_DOCKER_IMAGE" "/src/$RELATIVE_PATH" "${SCRIPT_ARGS[@]}"
}

main "$@"