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
			"logical_router_id": .logical_router_id,
			"mac_address": .mac_address,
			"ip_address": .subnets[0].ip_addresses[0],
			"prefix_length": .subnets[0].prefix_length
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
