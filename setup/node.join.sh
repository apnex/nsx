#!/bin/bash

THUMBPRINT=$(./thumbprint.sh ${1})
HOST=$(cat nsx-credentials | jq -r .hostname)

function isSuccess {
	local STRING=${1}
	REGEX='^(.*)([0-9]{3})$'
	if [[ $STRING =~ $REGEX ]]; then
		HTTPBODY=${BASH_REMATCH[1]}
		HTTPCODE=${BASH_REMATCH[2]}
		printf "[$HTTPCODE]" 1>&2
	fi
	if [[ $HTTPCODE -eq "200" ]]; then
		printf " - SUCCESS\n" 1>&2
	else
		printf " - ERROR\n" 1>&2
		printf "$HTTPBODY"
	fi
}

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
