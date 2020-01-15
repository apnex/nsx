#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

NODE=${1}
## add name as an input!
function makeBody {
	local NODE=${1}
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"resource_type": "HostNode",
		"display_name": "esx01.lab",
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
	CONFIG
	printf "${PAYLOAD}"
}

if [[ -n "${NODE}" ]]; then
	ESXPRINT=$(getThumbprint "${NODE}":443)
	if [[ -n "${NSXHOST}" && "${ESXPRINT}" ]]; then
	 	BODY=$(makeBody "${NODE}")
		URL="https://${NSXHOST}/api/v1/fabric/nodes"
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] node [$(cgreen "${NODE}"):$(cgreen "HostNode")] - [$(cgreen "$URL")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.join") $(ccyan "<ip-address>")\n" 1>&2
fi
