#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-ports"
INPUTS=()
INPUTS+=("logical-ports.spec")

# body
SPEC=${1}
function makeBody {
	BODY=$(<${SPEC})
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	NODEID=$(printf "${BODY}" | jq -r '.id')
	URL=$(buildURL "${ITEM}")
	URL+="/${NODEID}"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPut "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
