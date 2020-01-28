#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="dhcp/server-profiles"
valset "edge-cluster" "<edge-clusters.id>"
valset "dhcp-profile.name"

# body
CLSTID=${1}
NAME=${2}
function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name" : "${NAME}",
		"edge_cluster_id" : "${CLSTID}",
		"enable_standby_relocation" : true
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
