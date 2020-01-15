#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	read -r -d '' SPEC <<-CONFIG
		.results | if (. != null) then map({
			"id": .mac_address,
			"type": .mac_type
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
