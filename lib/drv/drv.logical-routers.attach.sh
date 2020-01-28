#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-router-ports"
valset "tier1-router" "<logical-routers.id;router_type:TIER1>"
valset "tier0-router" "<logical-routers.id;router_type:TIER0>"

# body
TIER1=${1}
TIER0=${2}
function makeBody {
	URL=$(buildURL "${ITEM}")
	read -r -d '' BODY <<-CONFIG
	{
	        "resource_type": "LogicalRouterLinkPortOnTIER0",
	        "display_name": "LinkedPort-T1",
	        "description": "Port created on Tier-0 router",
	        "logical_router_id": "${TIER0}"
	}
	CONFIG
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		PORTID=$(nsxPost "${URL}" "${BODY}" | jq -r '.id')
	fi

	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "LogicalRouterLinkPortOnTIER1",
		"linked_logical_router_port_id": {
			"target_id": "${PORTID}",
			"target_type": "LogicalRouterLinkPortOnTIER0"
		},
		"display_name": "LinkedPort-T0",
		"description": "Port created on Tier-1 router",
		"logical_router_id": "${TIER1}"
	}
	CONFIG
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# run
run() {
	makeBody
}

# driver
driver "${@}"
