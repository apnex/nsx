#!/bin/bash

THUMBPRINT=$(./sslthumbprint.sh ${1})
ENDPOINT="172.16.10.15"

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

URL="https://$ENDPOINT/api/v1/cluster/nodes?action=add_cluster_node"
printf "NSX create cluster node [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name": "mootroller01",
	"controller_role_config": {
		"type": "AddControllerNodeSpec",
		"host_msg_client_info": {
			"shared_secret": "VMware1!"
		},
		"mpa_msg_client_info": {
			"shared_secret": "VMware1!"
		}
	}
}
CONFIG
curl -v -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL"

#isSuccess "$RESPONSE" | jq --tab .
