#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

NAME=${1}
NODE=${2}

function makeBody {
	local NAME=${1}
	local NODE=${2}
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

if [[ -n "${NODE}" && "${NAME}" ]]; then
	ESXPRINT=$(getThumbprint "${NODE}":443)
	if [[ -n "${NSXHOST}" && "${ESXPRINT}" ]]; then
	 	BODY=$(makeBody "${NAME}" "${NODE}")
		ITEM="transport-nodes"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.join") $(ccyan "<node.name> <node.ip>")\n" 1>&2
fi
