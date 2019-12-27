#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

RPSPEC=${1}

# get latest revision
function makeBody {
	BODY=$(<${RPSPEC})
	printf "${BODY}"
}

ITEM="logical-router-ports"
if [[ -n "${RPSPEC}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		NODEID=$(printf "${BODY}" | jq -r '.id')
		URL=$(buildURL "${ITEM}")
		URL+="/${NODEID}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPut "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<rp.spec>")\n" 1>&2
fi
