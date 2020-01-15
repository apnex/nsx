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
			"computer_name": .guest_info.computer_name,
			"resource_type": .resource_type,
			"os_name": .guest_info.os_name,
			"tags": (.tags? |
				if (length > 0) then
					map([.scope, .tag] | join(":")) | join(",")
				else "" end
			),
			"power_state": .power_state,
			"source_name": .source.target_display_name,
			"source_type": .source.target_type
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
