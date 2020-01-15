#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

RTNAME=${1}
RTTYPE=${2}

function makeBody {
	## get edge-cluster
	local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')

	local TYPE=""
	case "${RTTYPE}" in
		"t0")
			TYPE="TIER0"
		;;
		"t1")
			TYPE="TIER1"
		;;
	esac

	#"edge_cluster_id": "${EDGEID}",
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
		"router_type": "${TYPE}",
		"high_availability_mode": "ACTIVE_STANDBY"
	}
	CONFIG
	printf "${BODY}"
}

ITEM="logical-routers"
if [[ -n "${RTNAME}" && "${RTTYPE}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
			#printf "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<name> <t0|t1>")\n" 1>&2
fi
