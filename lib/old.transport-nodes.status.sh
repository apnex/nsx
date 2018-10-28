#!/bin/bash
source drv.core
source drv.nsx.client

NODES=$(./drv.tnode.list.sh)

function getStatus {
	local NODEID=${1}
	ITEM="transport-nodes"
	CALL="/${NODEID}/state"
	URL=$(buildURL "${ITEM}${CALL}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "status")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
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
	NODEREC=$(echo "${NODE}" | jq --tab -r "[.id, .display_name, .node_id, .host_switch_spec.host_switches[0].host_switch_name]")

	# build status record
	NODESTAT=$(echo "${RESULT}" | jq --tab -r "[.state, .host_switch_states[0].endpoints[0].device_name, .host_switch_states[0].endpoints[0].ip]")
	MYBLAH=$(echo "$NODEREC$NODESTAT" |jq -s '. | add')

	# add to list
	FINAL+="$COMMA$(echo "$NODEREC$NODESTAT" | jq -s '. | add')"
	COMMA=","
done
FINAL="[$FINAL]"
printf "${FINAL}"
