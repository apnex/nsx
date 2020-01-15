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
			"logical_switch_id": .logical_switch_id,
			"admin_state": .admin_state,
			"attachment_type": .attachment.attachment_type
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
