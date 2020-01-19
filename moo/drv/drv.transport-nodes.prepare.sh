#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
INPUTS=()
INPUTS+=("transport-node.name")
INPUTS+=("<transport-nodes.id>")

# body
TNNAME=$1
TNID=$2
function makeBody {
	# get vlan and overlay tzs
	TZRESULT=$(${WORKDIR}/drv.transport-zones.list.sh 2>/dev/null)
	TZVLAN=$(echo "${TZRESULT}" | jq -r '.results | map(select(.display_name=="tz-vlan").id) | .[0]')
	TZOVERLAY=$(echo "${TZRESULT}" | jq -r '.results | map(select(.display_name=="tz-overlay").id) | .[0]')

	# get uplink profile
	PFRESULT=$(${WORKDIR}/drv.host-switch-profiles.list.sh json 2>/dev/null)
	PFUPLINK=$(echo "${PFRESULT}" | jq -r '.results | map(select(.display_name=="pf-host").id) | .[0]')

	# get tep pool
	PLRESULT=$(${WORKDIR}/drv.pool.list.sh 2>/dev/null)
	PLTEP=$(echo "${PLRESULT}" | jq -r '.results | map(select(.display_name=="pool-tep").id) | .[0]')

	# prepare without pnic
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
					"pnics": [],
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
	local BASEBODY=$(${WORKDIR}/drv.transport-nodes.list.sh 2>/dev/null | jq --tab '.results | map(select(.node_id=="'${TNID}'")) | .[0]')
	local MYNODE="$(echo "${BASEBODY}${BODY}" | jq -s '. | add')"
	printf "${MYNODE}"
}

# run
run() { # switch to patch?
	BODY=$(makeBody)
	ITEM="transport-nodes/${TNID}"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxPut "${URL}" "${BODY}"
	fi

	BODY=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null | jq --tab '.results | map(select(.id=="'${ECID}'")) | .[0]')
	NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
	printf "${NODE}" | jq --tab . >${WORKDIR}/ec.spec
	${WORKDIR}/drv.edge-clusters.patch.sh ${WORKDIR}/ec.spec
}

# driver
driver "${@}"
