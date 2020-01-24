#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="edge-clusters"
valset "edge-cluster.name"

# body
CLSTNAME=$1
function makeBody {
	RESULT=$(${WORKDIR}/drv.cluster-profiles.list.sh 2>/dev/null)
	PFCLST=$(echo "${RESULT}" | jq -r '.results | map(select(.resource_type=="EdgeHighAvailabilityProfile").id) | .[0]')

	read -r -d '' BODY <<-CONFIG
	{
		"display_name": "${CLSTNAME}",
		"cluster_profile_bindings": [
			{
				"profile_id": "${PFCLST}",
				"resource_type": "EdgeHighAvailabilityProfile"
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
