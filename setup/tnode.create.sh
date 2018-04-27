#!/bin/bash
source drv.core

TNNAME=$1
TNNODEID=$2

## testing dynamic values - need to convert to nsx object tags!
TZRESULT=$(./drv.tzone.list.sh 2>/dev/null)
TZVLAN=$(echo "${TZRESULT}" | jq -r '.results[] | first(select(.transport_type=="VLAN")).id')
TZOVERLAY=$(echo "${TZRESULT}" | jq -r '.results[] | first(select(.transport_type=="OVERLAY")).id')
echo "$TZVLAN"
echo "$TZOVERLAY"

PFRESULT=$(./drv.profile.list.sh json 2>/dev/null)
PFUPLINK=$(echo "${PFRESULT}" | jq -r '.results[] | select(.display_name=="pf-uplink").id')

PLRESULT=$(./drv.pool.list.sh 2>/dev/null)
PLTEP=$(echo "${PLRESULT}" | jq -r '.results[] | select(.display_name=="tep-pool").id')

DEVICENAME="vmnic1"
DEVICENAME="fp-eth0"

read -r -d '' CONTEXT <<-CONFIG
{
	"transport-zones": [
		"${TZVLAN}",
		"${TZOVERLAY}"
	]
}
CONFIG

read -r -d '' PAYLOAD <<-CONFIG
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
echo "$PAYLOAD" | jq --tab .

function request {
	local TNNAME=${1}
	URL="https://$HOST/api/v1/transport-nodes"
	printf "[INFO] nsx [create] transport-node [${TNNAME}] - [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

if [[ -n "${TNNAME}" && "${TNNODEID}" ]]; then
	request "${TNNAME}"
else
	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tnode.create${LIGHTCYAN} <tnname> <nodeid>${NC}\n" 1>&2
fi
