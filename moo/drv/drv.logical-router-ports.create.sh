#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-router-ports"
INPUTS=()
INPUTS+=("<logical-routers.id>")
INPUTS+=("<logical-ports.id>")
INPUTS+=("logical-router-port.prefix")
INPUTS+=("logical-router-port.name")

# body
LRID=${1}
LPID=${2}
RPADDR=${3}
RPNAME=${4}

function makeBody {
	## check existing port?
	#local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	#local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')

	# if LRID = TIER1? Change to DownLinkPort
	if [[ $RPADDR =~ ^([.0-9]+)\/([0-9]+) ]]; then
		local IPADDR="${BASH_REMATCH[1]}"
		local PREFIX="${BASH_REMATCH[2]}"
	fi
	local TYPE="LogicalRouterDownLinkPort"
	#local TYPE="LogicalRouterUpLinkPort"
	read -r -d '' BODY <<-CONFIG
	{
		"logical_router_id": "${LRID}",
		"resource_type": "${TYPE}",
		"display_name": "${RPNAME}",
		"linked_logical_switch_port_id": {
			"target_type": "LogicalPort",
			"target_id": "${LPID}"
		},
		"subnets": [
			{
				"ip_addresses": [
					"${IPADDR}"
				],
				"prefix_length": "${PREFIX}"
			}
		]
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
