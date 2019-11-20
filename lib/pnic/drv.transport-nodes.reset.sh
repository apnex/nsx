#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

read -r -d '' JQSPEC <<-CONFIG
	{
		node_id,
		maintenance_mode,
		node_deployment_info,
		is_overridden,
		id,
		resource_type,
		display_name,
		host_switches,
		description,
		_create_user,
		_create_time,
		_last_modified_user,
		_last_modified_time,
		_system_owned,
		_protection,
		_revision
	}
CONFIG

if [[ -n "${1}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(./drv.transport-nodes.list.sh | jq '.results | map(select(.node_id=="'${1}'")) | .[0]')
		NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
		printf "${NODE}" | jq --tab . > tn.spec
		./drv.transport-nodes.update.sh tn.spec
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.reset") $(ccyan "<node-uuid>")\n" 1>&2
fi

