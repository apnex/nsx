#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

TNSPEC=$1
# get latest revision
function makeBody {
	BODY=$(cat ${WORKDIR}/${TNSPEC})
	printf "${BODY}"
}

if [[ -n "${TNSPEC}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		NODEID=$(printf "${BODY}" | jq -r '.node_id')
		ITEM="transport-nodes/${NODEID}"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPut "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.update") $(ccyan "<tn.spec>")\n" 1>&2
fi
