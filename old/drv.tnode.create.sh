#!/bin/bash
TNNAME=$1
TNNODEID=$2

## testing dynamic values - need to convert to nsx object tags!
TZRESULT=$(./drv.tzone.list.sh 2>/dev/null)
TZVLAN=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="VLAN").id) | .[0]')
TZOVERLAY=$(echo "${TZRESULT}" | jq -r '.results | map(select(.transport_type=="OVERLAY").id) | .[0]')
echo "$TZVLAN [VLAN]"
echo "$TZOVERLAY [OVERLAY]"

PFRESULT=$(./drv.profile.list.sh json 2>/dev/null)
PFUPLINK=$(echo "${PFRESULT}" | jq -r '.results | map(select(.display_name=="pf-uplink").id) | .[0]')

PLRESULT=$(./drv.pool.list.sh 2>/dev/null)
PLTEP=$(echo "${PLRESULT}" | jq -r '.results | map(select(.display_name==tep-pool").id) | .[0]')

DEVICENAME="vmnic1"
DEVICENAME="fp-eth0"

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

function green {
	local STRING=${1}
	printf "${GREEN}${STRING}${NC}"
}

if [[ "$RAW" == "json" ]]; then
	echo "${CONTEXT}" | jq --tab .
else
	source drv.core
source drv.nsx.client
	if [[ -n "${TNNAME}" && "${TNNODEID}" ]]; then
		# get other variables
		if [[ -n "${NSXHOST}" ]]; then
		 	BODY=$(makeBody)
			URL="https://$HOST/api/v1/transport-nodes"
			printf "[$(green "INFO")]: nsx [$(green "create")] transport-node [$(green "${$TNNAME}"):$(green "${$TNNODEID}")] - [$(green "$URL")]... " 1>&2
			#nsxPost "${URL}" "${BODY}"
		fi
	else
		printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tnode.create${LIGHTCYAN} <tnname> <nodeid>${NC}\n" 1>&2
	fi
fi
