#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to mod.header
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

## input driver
INPUT=$(${WORKDIR}/drv.logical-ports.list.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"id": .id,
		"name": .display_name,
		"resource_type": .resource_type,
		"logical_switch_id": .logical_switch_id,
		"admin_state": .admin_state,
		"attachment_type": .attachment.attachment_type
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

## run
run "${PAYLOAD}" ${1} ${2}
