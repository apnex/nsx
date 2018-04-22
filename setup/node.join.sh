#!/bin/bash
source ./drv.core
THUMBPRINT=$(./thumbprint.sh ${1})

URL="https://$HOST/api/v1/fabric/nodes"
printf "NSX join host [${1}] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "HostNode",
	"display_name": "esx01.lab",
	"ip_addresses": [
		"172.16.10.101"
	],
	"os_type": "ESXI",
	"host_credential": {
		"username": "root",
		"password": "VMware1!",
		"thumbprint": "${THUMBPRINT}"
	}
}
CONFIG
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE" | jq --tab .
