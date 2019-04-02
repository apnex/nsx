#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
INPUT=$(${WORKDIR}/drv.host.switch.list.sh "${1}")

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	. | map({
		"name": .name,
		"used_ports": .used_ports,
		"configured_ports": .configured_ports,
		"mtu": .mtu,
		"cdp_status": .cdp_status,
		"uplinks": .uplinks,
		"portgroups": .portgroups
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

# build filter
#FILTER=${1}
#FORMAT=${2}
#PAYLOAD=$(filter "${PAYLOAD}" "${FILTER}")

## cache context data record
#setContext "$PAYLOAD" "$TYPE"

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
