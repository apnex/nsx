#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-router-ports"
valset "tier1-router" "<logical-routers.id;router_type:TIER1>"

# body
TIER1=${1}
function makeBody {
	# get T1 port id
	read -r -d '' JQSPEC <<-CONFIG
		.results | map(select(.logical_router_id=="${TIER1}"))
		| map(select(.linked_logical_router_port_id.target_type=="LogicalRouterLinkPortOnTIER0"))
		| .[0]
	CONFIG
	local T1PORT=$(${WORKDIR}/drv.logical-router-ports.list.sh | jq -r "${JQSPEC}")
	local T1PORTID=$(printf "${T1PORT}" | jq -r '.id')
	local T0PORTID=$(printf "${T1PORT}" | jq -r '.linked_logical_router_port_id.target_id')

	# delete T1 port
	if [[ -n ${T1PORTID} ]]; then
		local URL=$(buildURL "${ITEM}")
		URL+="/${T1PORTID}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxDelete "${URL}"
		fi
	fi

	# delete T0 port
	if [[ -n ${T0PORTID} ]]; then
		local URL=$(buildURL "${ITEM}")
		URL+="/${T0PORTID}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxDelete "${URL}"
		fi
	fi
}

# run
run() {
	makeBody
}

# driver
driver "${@}"
