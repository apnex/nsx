#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	## input driver
	INPUT=$(${WORKDIR}/drv.virtual-machines.list.sh)

	## build record structure
	read -r -d '' INPUTSPEC <<-CONFIG
		.results | if (. != null) then map({
			"id": .external_id,
			"name": .display_name,
			"computer_name": .guest_info.computer_name,
			"resource_type": .resource_type,
			"os_name": .guest_info.os_name,
			"tags": [.tags[] | [.tag, .scope] | join(":")] | join(","),
			"power_state": .power_state,
			"source_name": .source.target_display_name,
			"source_type": .source.target_type
		}) else "" end
	CONFIG

	# output
	PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")
	printf "${PAYLOAD}"
}

## cmd
cmd "${@}"
