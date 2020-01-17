#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-switches"
INPUTS=()
INPUTS+=("logical-switch.name")
INPUTS+=("<transport-zones.id>")
INPUTS+=("vlan")

# body
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

# run
run() {
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
