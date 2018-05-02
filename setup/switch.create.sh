#!/bin/bash
SWNAME=${1}
SWTZ=${2}
SWVLAN=${3}

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name": "$SWNAME",
		"description": "$SWNAME",
		"transport_zone_id": "${SWTZ}",
		"replication_mode": "MTEP",
		"admin_state": "UP",
		"vlan": "${SWVLAN}"
	}
	CONFIG
	printf "${BODY}"
}

source drv.core
if [[ -n "${SWNAME}" && "${SWTZ}" ]]; then
	if [[ -n "${HOST}" ]]; then
		BODY=$(makeBody)
		ITEM="logical-switches"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "switch.create") $(ccyan "<name> <tz-uuid> [ <vlan> ]")\n" 1>&2
fi
