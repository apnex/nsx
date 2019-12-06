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
		.results | if (. != null) then map({
			"id": .id,
			"name": .display_name,
			"resource_type": .resource_type,
			"ip_addresses": .ip_addresses[0]
		}) else "" end
	CONFIG

	# output
	PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")
	printf "${PAYLOAD}"
}

## cmd
cmd "${@}"
