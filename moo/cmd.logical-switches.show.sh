#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	read -r -d '' SPEC <<-CONFIG
		. | if (. != null) then map({
			"id": .id,
			"name": .name,
			"vni": .vni,
			"vlan": .vlan,
			"admin_state": .admin_state,
			"state" : .state
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
