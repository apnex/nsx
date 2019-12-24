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
			"host_switch_name": .host_switch_name,
			"transport_type": .transport_type
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
