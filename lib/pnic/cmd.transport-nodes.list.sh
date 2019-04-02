#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
INPUT=$(${WORKDIR}/drv.transport-nodes.list.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"id": .id,
		"name": .display_name,
		"resource_type": .node_deployment_info.resource_type,
		"ip_address": .node_deployment_info.ip_addresses[0],
		"os_type": .node_deployment_info.os_type,
		"os_version": .node_deployment_info.os_version,
		"host_switch": .host_switch_spec.host_switches[0].host_switch_name
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

# build filter
FILTER=${1}
FORMAT=${2}
PAYLOAD=$(filter "${PAYLOAD}" "${FILTER}")

## cache context data record
setContext "$PAYLOAD" "$TYPE"

## output
case "${FORMAT}" in
	json)
		## build payload json
		echo "${PAYLOAD}" | jq --tab .
	;;
	raw)
		## build input json
		echo "${INPUT}" | jq --tab .
	;;
	*)
		## build payload table
		buildTable "${PAYLOAD}"
	;;
esac
