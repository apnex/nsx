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
			"deployment_type": .deployment_type,
			"members": (.members? |
				if (length > 0) then
					.[] | .transport_node_id
				else "" end
			)
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
