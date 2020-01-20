#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="traceflows"
INPUTS=()
INPUTS+=("traceflow.spec")
INPUTS+=("<logical-ports.id>")

# body
SPEC=${1}
PORT=${2}
function makeBody {
	MYSPEC=$(<${SPEC})
	read -r -d '' JQSPEC <<-CONFIG
		.lport_id = "${PORT}"
	CONFIG
	local BODY=$(echo "${MYSPEC}" | jq -r "$JQSPEC")
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
