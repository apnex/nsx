#!/bin/bash
TNNAME=$1
TNNODEID=$2

# test model
read -r -d '' CONTEXT <<-CONFIG
{
	"display_name": "${TNNAME}",
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
	TZRESULT=$(./drv.tzone.list.sh 2>/dev/null)
	TZVLAN=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="VLAN").id) | .[0]')
	TZOVERLAY=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="OVERLAY").id) | .[0]')

	# get uplink profile
	PFRESULT=$(./drv.profile.list.sh json 2>/dev/null)
	PFUPLINK=$(echo "${PFRESULT}" | jq -r '.results | map(select(.display_name=="pf-uplink").id) | .[0]')

	# get tep pool
	PLRESULT=$(./drv.pool.list.sh 2>/dev/null)
	PLTEP=$(echo "${PLRESULT}" | jq -r '.results | map(select(.display_name=="tep-pool").id) | .[0]')

	# determine node type
	NODERESULT=$(./drv.node.list.sh json 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG # collapse into single line
		.results
			| map(select(.id=="${TNNODEID}").resource_type)
				| .[0]
	CONFIG
	NODETYPE=$(echo "${NODERESULT}" | jq -r "$JQSPEC")
	DEVICENAME=""
	case "${NODETYPE}" in
		"EdgeNode")
			DEVICENAME="fp-eth0"
		;;
		"HostNode")
			DEVICENAME="vmnic1"
		;;
	esac

	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "TransportNode",
		"display_name": "${TNNAME}",
		"description": "NSX configured Test Transport Node",
		"node_id": "${TNNODEID}",
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

source drv.core
if [[ -n "${TNNAME}" && "${TNNODEID}" ]]; then
	if [[ -n "${HOST}" ]]; then
		BODY=$(makeBody)
		ITEM="transport-nodes"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "tnode.create") $(ccyan "<name> <node-uuid>")\n" 1>&2
fi
