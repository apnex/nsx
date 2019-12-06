#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	## input driver
	INPUT=$(${WORKDIR}/drv.${TYPE}.sh)

	## build record structure
	read -r -d '' INPUTSPEC <<-CONFIG
		. | if (. != null) then map({
			"id": .id,
			"name": .name,
			"resource_type": .resource_type,
			"ip_address": .ip_address,
			"host_switch": .host_switch,
			"status": .status,
			"state": .state,
			"software_version": .software_version
		}) else "" end
	CONFIG

	# output
	PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")
	printf "${PAYLOAD}"
}

## cmd
cmd "${@}"
