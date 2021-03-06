#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	read -r -d '' SPEC <<-CONFIG
		.results | if (. != null) then map({
			"id": .external_id,
			"name": .display_name,
			"resource_type": .resource_type,
			"ip_addresses": .ip_addresses[0]
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
