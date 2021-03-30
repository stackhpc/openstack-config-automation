#!/bin/bash

set -eu
set -o pipefail

# Builds images

PARENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${PARENT}/../functions"


function main {
    openstack_config_init
    run_openstack_config "$@"
}

main "$@"
