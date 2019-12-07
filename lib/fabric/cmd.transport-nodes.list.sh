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
			"resource_type": .node_deployment_info.resource_type,
			"ip_address": .node_deployment_info.ip_addresses[0],
			"os_type": .node_deployment_info.os_type,
			"os_version": .node_deployment_info.os_version,
			"host_switch": .host_switch_spec.host_switches[0].host_switch_name
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
