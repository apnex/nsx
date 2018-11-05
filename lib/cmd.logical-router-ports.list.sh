#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
INPUT=$(${WORKDIR}/drv.logical-router-ports.list.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"id": .id,
		"name": .display_name,
		"resource_type": .resource_type,
		"logical_router_id": .logical_router_id,
		"mac_address": .mac_address,
		"ip_address": .subnets[0].ip_addresses[0],
		"prefix_length": .subnets[0].prefix_length
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
