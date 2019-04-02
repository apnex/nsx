#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

TNNAME=$1
TNID=$2

function makeBody {
	# get vlan and overlay tzs
	TZRESULT=$(./drv.transport-zones.list.sh 2>/dev/null)
	TZVLAN=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="VLAN").id) | .[0]')
	TZOVERLAY=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="OVERLAY").id) | .[0]')

	# get uplink profile
	PFRESULT=$(./drv.host-switch-profiles.list.sh json 2>/dev/null)
	PFUPLINK=$(echo "${PFRESULT}" | jq -r '.results | map(select(.display_name=="pf-uplink").id) | .[0]')

	# get tep pool
	PLRESULT=$(./drv.pool.list.sh 2>/dev/null)
	PLTEP=$(echo "${PLRESULT}" | jq -r '.results | map(select(.display_name=="pool-tep").id) | .[0]')

	## adjust to support multiple uplinks
	DEVICENAME="vmnic1"
	read -r -d '' BODY <<-CONFIG
	{
		"display_name": "${TNNAME}",
		"description": "NSX configured Test Transport Node",
		"host_switch_spec": {
			"resource_type": "StandardHostSwitchSpec",
			"host_switches": [
				{
					"host_switch_profile_ids": [
						{
							"value": "${PFUPLINK}",
							"key": "UplinkHostSwitchProfile"
						}
					],
					"host_switch_name": "hs-fabric",
					"pnics": [
						{
							"device_name": "${DEVICENAME}",
							"uplink_name": "uplink1"
						}
					],
					"ip_assignment_spec": {
						"resource_type": "StaticIpPoolSpec",
						"ip_pool_id": "${PLTEP}"
					}
				}
			]
		},
		"transport_zone_endpoints": [
			{
				"transport_zone_id": "${TZVLAN}"
			},
			{
				"transport_zone_id": "${TZOVERLAY}"
			}
		]
	}
	CONFIG
	local BASEBODY=$(./drv.transport-nodes.get.sh "${TNID}" 2>/dev/null)
	local MYNODE="$(echo "${BASEBODY}${BODY}" | jq -s '. | add')"
	printf "${MYNODE}"
}

if [[ -n "${TNNAME}" && "${TNID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="transport-nodes/${TNID}"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPut "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.update") $(ccyan "<name> <node.id>")\n" 1>&2
fi
