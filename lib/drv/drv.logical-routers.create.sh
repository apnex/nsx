#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-routers"
valset "logical-router.name"
valset "logical-router.type" "<[TIER0,TIER1]>"

# body
RTNAME=${1}
RTTYPE=${2}
function makeBody {
	## get edge-cluster
	local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')

	#local TYPE=""
	#case "${RTTYPE}" in
	#	"t0")
	#		TYPE="TIER0"
	#	;;
	#	"t1")
	#		TYPE="TIER1"
	#	;;
	#esac
	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "LogicalRouter",
		"description": "Logical router",
		"display_name": "${RTNAME}",
		"advanced_config": {
			"external_transit_networks": [
				"100.64.0.0/10"
			],
			"internal_transit_network": "169.254.0.0/28"
		},
		"router_type": "${RTTYPE}",
		"high_availability_mode": "ACTIVE_STANDBY",
		"edge_cluster_id": "${EDGEID}"
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
