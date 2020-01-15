#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	read -r -d '' SPEC <<-CONFIG
		.results | if (. != null) then map({
			"id": .id,
			"name": .display_name,
			"resource_type": .resource_type,
			"transport_vlan": .transport_vlan,
			"mtu": .mtu
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
