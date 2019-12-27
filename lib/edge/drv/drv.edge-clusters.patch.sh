#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

ECSPEC=$1

# get latest revision
function makeBody {
	BODY=$(<${ECSPEC})
	printf "${BODY}"
}

if [[ -n "${ECSPEC}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		NODEID=$(printf "${BODY}" | jq -r '.id')
		ITEM="edge-clusters/${NODEID}"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPut "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<ec.spec>")\n" 1>&2
fi
