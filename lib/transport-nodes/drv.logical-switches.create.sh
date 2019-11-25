#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

SWNAME=${1}
SWTZ=${2}
SWVLAN=${3}
function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name": "${SWNAME}",
		"description": "${SWNAME}",
		"transport_zone_id": "${SWTZ}",
		"replication_mode": "MTEP",
		"admin_state": "UP",
		"vlan": "${SWVLAN}"
	}
	CONFIG
	printf "${BODY}"
}

if [[ -n "${SWNAME}" && "${SWTZ}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="logical-switches"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "logical-switches.create") $(ccyan "<name> <transport-zone.id> [ <vlan> ]")\n" 1>&2
fi
