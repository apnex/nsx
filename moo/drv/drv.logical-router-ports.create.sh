#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

LRID=${1}
RPNAME=${2}
LPID=${3}

function makeBody {
	## check existing port?
	#local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	#local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')

	# if LRID = TIER1? Change to DownLinkPort
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
					"172.20.10.1"
				],
				"prefix_length": 24
			}
		]
	}
	CONFIG
	#	],
	#	"edge_cluster_member_index": [
	#		0
	printf "${BODY}"
}

ITEM="logical-router-ports"
if [[ -n "${LRID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<logical-router.id> <name> <logical-port.id>")\n" 1>&2
fi
