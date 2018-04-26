#!/bin/bash
source drv.core
NODE=${1}

function request {
	ESXPRINT=$(./thumbprint.sh "$1")
	URL="https://$HOST/api/v1/fabric/nodes"
	printf "NSX join NODE [$1] - [$URL]... " 1>&2
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"resource_type": "HostNode",
		"display_name": "esx01.lab",
		"ip_addresses": [
			"$1"
		],
		"os_type": "ESXI",
		"host_credential": {
			"username": "root",
			"password": "VMware1!",
			"thumbprint": "$ESXPRINT"
		}
	}
	CONFIG
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE" | jq --tab .
}

if [[ -n "${NODE}" ]]; then
	request "${NODE}"
else
	printf "[${ORANGE}ERROR${NC}]: command usage: ${GREEN}node.join${LIGHTCYAN} <ip-address>${NC}\n" 1>&2
fi
