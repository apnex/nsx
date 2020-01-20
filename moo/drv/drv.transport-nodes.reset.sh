#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
INPUTS=()
INPUTS+=("<transport-nodes.id>")

# body
TNID=${1}
function makeBody {
	local NODE=$(${WORKDIR}/drv.${ITEM}.list.sh 2>/dev/null | jq -r '.results | map(select(.node_id=="'${TNID}'")) | .[0]')
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
	local BODY=$(echo "${NODE}" | jq -r "$JQSPEC")
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	printf "${BODY}" | jq --tab . >${WORKDIR}/tn.spec
	${WORKDIR}/drv.${ITEM}.update.sh ${WORKDIR}/tn.spec
}

# driver
driver "${@}"
