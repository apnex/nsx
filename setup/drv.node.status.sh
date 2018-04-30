#!/bin/bash
source drv.core

NODES=$(./drv.node.list.sh)

function getStatus {
	local NODEID=${1}
	ITEM="fabric/nodes"
	CALL="/${NODEID}/status"
	URL=$(buildURL "${ITEM}${CALL}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		rGet "${URL}"
	fi
}

FINAL=""
COMMA=""
for key in $(echo ${NODES} | jq -r '.results[] | .id'); do
	#get node
	read -r -d '' JQSPEC <<-CONFIG # collapse into single line
		.results[]
			| select(.id=="${key}")
	CONFIG
	NODE=$(echo ${NODES} | jq -r "$JQSPEC")

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
printf "${FINAL}"
