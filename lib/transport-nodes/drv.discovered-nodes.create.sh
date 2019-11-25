#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

DNNAME=$1
DNODEID=$2

# test model
read -r -d '' CONTEXT <<-CONFIG
{
	"display_name": "${DNNAME}",
	"host_switches": [
		{
			"host_switch_name": "hs-fabric"
		}
	],
	"transport-zones": [
		"${TZVLAN}",
		"${TZOVERLAY}"
	]
}
CONFIG

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

	## temp hack
	DEVICENAME="vmnic0"

	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "TransportNode",
		"display_name": "${DNNAME}",
		"description": "NSX configured Test Transport Node",
		"node_id": "${DNODEID}",
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
	printf "${BODY}"
}

if [[ -n "${DNNAME}" && "${DNODEID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="fabric/discovered-nodes/${DNODEID}"
		URL=$(buildURL "${ITEM}")
		URL+="?action=create_transport_node"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "discovered-nodes.create") $(ccyan "<name> <dnode-uuid>")\n" 1>&2
fi
