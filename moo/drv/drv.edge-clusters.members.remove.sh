#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

ECID=${1}
TNID=${2}

read -r -d '' JQSPEC <<-CONFIG # override member in JSON
	.members |= (
		del(.[] | select(.transport_node_id=="${TNID}"))
	)
CONFIG

if [[ -n "${ECID}" && -n "${TNID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null | jq --tab '.results | map(select(.id=="'${ECID}'")) | .[0]')
		NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
		printf "${NODE}" | jq --tab . >${WORKDIR}/ec.spec
		${WORKDIR}/drv.edge-clusters.patch.sh ${WORKDIR}/ec.spec
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<edge-cluster.id> <transport-node.id>")\n" 1>&2
fi
