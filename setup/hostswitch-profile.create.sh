#!/bin/bash
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

source drv.core
if [[ -n "${PFNAME}" && "${PFMTU}" && "${PFVLAN}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="host-switch-profiles"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "profile.create") $(ccyan "<name> <mtu> <vlan>")\n" 1>&2
fi
