#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-zones"
valset "transport-zone.name"
valset "host-switch.name"
valset "transport-zone.type" "<[OVERLAY,VLAN]>"

# body
TZNAME=$1
TZSWITCH=$2
TZTYPE=$3
function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name":"$TZNAME",
		"host_switch_name":"$TZSWITCH",
		"description":"$TZTYPE Transport-Zone",
		"transport_type":"$TZTYPE"
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
