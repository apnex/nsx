#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
#INPUT=$(cat moo)
INPUT=$(${WORKDIR}/drv.vifs.list.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"id": .lport_attachment_id,
		"name": .device_name,
		"resource_type": .resource_type,
		"device_key": .device_key,
		"ip_addresses": [.ip_address_info[].ip_addresses[]] | join(","),
		"mac_address": .mac_address,
		"owner_vm_id": .owner_vm_id
	})
CONFIG
#		"ip_addresses": [.ip_address_info[].ip_addresses[] | [.tag, .scope] | join(",")] | join(","),
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
