#!/bin/bash
source drv.core
source drv.nsx.client

NODES=$(./drv.node.list.sh)

function getStatus {
	local NODEID=${1}
	URL="https://$HOST/api/v1/fabric/nodes/${NODEID}/status"
	printf "Retrieving [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X GET \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
	echo "$HTTPBODY"
}

FINAL=""
COMMA=""
for key in $(echo ${NODES} | jq -r '.results[] | .id'); do
	#get node
	NODE=$(echo ${NODES} | jq -r ".results[] | select(.id=='${key}'")

	# get node status
	RESULT=$(getStatus "$key")

	# build node record
	NODEREC=$(echo "${NODE}" | jq --tab -r "[.id, .resource_type, .display_name, .ip_addresses[0]]")

	# build node record
	NODESTAT=$(echo "${RESULT}" | jq --tab -r "[.host_node_deployment_status, .software_version]")
	MYBLAH=$(echo "$NODEREC$NODESTAT" |jq -s '. | add')

	# add to list
	FINAL+="$COMMA$(echo "$NODEREC$NODESTAT" | jq -s '. | add')"
	COMMA=","
done
FINAL="[$FINAL]"

read -r -d '' JQSPEC <<CONFIG
	.
		| ["id", "resource_type", "display_name", "ip_address", "status", "version"]
		, ["-----", "-----", "-----", "-----", "-----"]
		, (.[] | [.[0], .[1], .[2], .[3], .[4], .[5]])
	| @csv
CONFIG
echo "$FINAL" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
