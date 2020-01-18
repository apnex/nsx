#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="host-switch-profiles"
INPUTS=()
INPUTS+=("host-switch-profile.name")
INPUTS+=("host-switch-profile.mtu")
INPUTS+=("tep.vlan")

# body
PFNAME=$1
PFMTU=$2
PFVLAN=$3
function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "UplinkHostSwitchProfile",
		"display_name": "$PFNAME",
		"mtu": $PFMTU,
		"teaming": {
			"standby_list": [],
			"active_list": [
				{
					"uplink_name": "uplink1",
					"uplink_type": "PNIC"
				}
			],
			"policy": "FAILOVER_ORDER"
		},
		"transport_vlan": $PFVLAN
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
