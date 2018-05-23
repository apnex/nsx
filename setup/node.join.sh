#!/bin/bash
NODE=${1}

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

function green {
	local STRING=${1}
	printf "${GREEN}${STRING}${NC}"
}

source drv.core
if [[ -n "${NODE}" ]]; then
	ESXPRINT=$(./thumbprint.sh "$1")
	if [[ -n "${NSXHOST}" && "${ESXPRINT}" ]]; then
	 	BODY=$(makeBody "${NODE}")
		URL="https://${NSXHOST}/api/v1/fabric/nodes"
		printf "[$(green "INFO")]: nsx [$(green "create")] node [$(green "${NODE}"):$(green "HostNode")] - [$(green "$URL")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
else
	printf "[${ORANGE}ERROR${NC}]: command usage: ${GREEN}node.join${LIGHTCYAN} <ip-address>${NC}\n" 1>&2
fi
