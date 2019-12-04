#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/mod.core

## input driver
INPUT=$(${WORKDIR}/drv.virtual-machines.list.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"id": .external_id,
		"name": .display_name,
		"computer_name": .guest_info.computer_name,
		"resource_type": .resource_type,
		"os_name": .guest_info.os_name,
		"tags": [.tags[] | [.tag, .scope] | join(":")] | join(","),
		"power_state": .power_state,
		"source_name": .source.target_display_name,
		"source_type": .source.target_type
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
