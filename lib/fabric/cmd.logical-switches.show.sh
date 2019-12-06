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
			"vni": .vni,
			"vlan": .vlan,
			"admin_state": .admin_state,
			"state" : .state
		}) else "" end
	CONFIG

	# output
	PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")
	printf "${PAYLOAD}"
}

## cmd
cmd "${@}"
