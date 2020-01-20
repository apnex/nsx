#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
INPUTS=()
INPUTS+=("transport-node.name")
INPUTS+=("esx.ip-address")

# body
NAME=${1}
NODE=${2}
function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"node_deployment_info": {
			"resource_type": "HostNode",
			"display_name": "$NAME",
			"ip_addresses": [
				"${NODE}"
			],
			"os_type": "ESXI",
			"host_credential": {
				"username": "root",
				"password": "VMware1!",
				"thumbprint": "$ESXPRINT"
			}
		}
	}
	CONFIG
	printf "${PAYLOAD}"
}

# run
run() {
	ESXPRINT=$(getThumbprint "${NODE}":443)
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
