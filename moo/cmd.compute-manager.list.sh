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
			"server": .server,
			"origin": .origin_type,
			"version": (
				if (.origin_properties | length) != 0 then
					(.origin_properties[] | select(.key=="version").value)
				else
					"not-registered"
				end
			)
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
