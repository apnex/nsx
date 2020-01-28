#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-router-ports"
valset "logical-router" "<logical-routers.id>"
valset "logical-port" "<logical-ports.id;attachment_type:^$>"
valset "router-port.type" "<[LogicalRouterUpLinkPort,LogicalRouterDownLinkPort]>"
valset "edge.index" "<[0,1]>"
valset "router-port.prefix"
valset "router-port.name"

# body
LRID=${1}
LPID=${2}
RPTYPE=${3}
EINDEX=${4}
RPADDR=${5}
RPNAME=${6}
function makeBody {
	## check existing port?
	#local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	#local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')

	# if LRID = TIER1? Change to DownLinkPort
	if [[ $RPADDR =~ ^([.0-9]+)\/([0-9]+) ]]; then
		local IPADDR="${BASH_REMATCH[1]}"
		local PREFIX="${BASH_REMATCH[2]}"
	fi
	read -r -d '' BODY <<-CONFIG
	{
		"logical_router_id": "${LRID}",
		"resource_type": "${RPTYPE}",
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
		],
		"edge_cluster_member_index": [
			"${EINDEX}"
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
