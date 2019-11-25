#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

CLSTNAME=$1
TNID=$2
function makeBody {
	RESULT=$(./drv.cluster-profile.list.sh 2>/dev/null)
	PFCLST=$(echo "${RESULT}" | jq -r '.results | map(select(.resource_type=="EdgeHighAvailabilityProfile").id) | .[0]')

 	# determine node exists
	NODERESULT=$(./drv.transport-nodes.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results
			| map(select(.id=="${TNID}").name)
			| .[0]
	CONFIG
	NODETYPE=$(echo "${NODERESULT}" | jq -r "$JQSPEC")
	if [[ -n "${NODETYPE}" ]]; then
		read -r -d '' BODY <<-CONFIG
		{
			"display_name": "${CLSTNAME}",
			"cluster_profile_bindings": [
				{
					"profile_id": "${PFCLST}",
					"resource_type": "EdgeHighAvailabilityProfile"
				}
			],
			"members":  [
		 		{
					"transport_node_id": "${TNID}"
				}
			]
		}
		CONFIG
	fi # add error handling for missing dynamic parameters
	printf "${BODY}"
}

ITEM="edge-clusters"
if [[ -n "${CLSTNAME}" && "${TNID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "${ITEM}.create") $(ccyan "<name> <transport-node.id>")\n" 1>&2
fi
