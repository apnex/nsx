#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

## input driver
NODES=$(${WORKDIR}/drv.transport-nodes.list.sh)

function buildNode {
	local KEY=${1}

	read -r -d '' JQSPEC <<-CONFIG # collapse into single line
		.results[] | select(.id=="${KEY}")
	CONFIG
	NODE=$(echo ${NODES} | jq -r "$JQSPEC")

	# build node record
	read -r -d '' NODESPEC <<-CONFIG
		{
			"id": .id,
			"name": .display_name,
			"resource_type": .node_deployment_info.resource_type,
			"host_switch": .host_switch_spec.host_switches[0].host_switch_name,
			"ip_address": .node_deployment_info.ip_addresses[0]
		}
	CONFIG
	NEWNODE=$(echo "${NODE}" | jq -r "${NODESPEC}")

	## get node status
	RESULT=$($WORKDIR/drv.transport-nodes.status.sh "$KEY")
	read -r -d '' STATUSSPEC <<-CONFIG
		{
			"status": .node_status.host_node_deployment_status,
			"state": .status,
			"software_version": .node_status.software_version
		}
	CONFIG
	NEWSTAT=$(echo "${RESULT}" | jq -r "${STATUSSPEC}")

	# merge node and status
	MYNODE="$(echo "${NEWNODE}${NEWSTAT}" | jq -s '. | add')"
	printf "%s\n" "${MYNODE}"
}

FINAL="[]"
for KEY in $(echo ${NODES} | jq -r '.results[] | .id'); do
	MYNODE=$(buildNode "${KEY}")
	FINAL="$(echo "${FINAL}[${MYNODE}]" | jq -s '. | add')"
done
printf "${FINAL}" | jq --tab .
