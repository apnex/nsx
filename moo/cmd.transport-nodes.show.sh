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
			"resource_type": .resource_type,
			"ip_address": .ip_address,
			"host_switch": .host_switch,
			"status": .status,
			"state": .state,
			"software_version": .software_version
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
