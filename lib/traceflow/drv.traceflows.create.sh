#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

SPEC=${1}
PORT=${2}
function makeBody {
	MYSPEC=$(cat "${SPEC}")
	read -r -d '' JQSPEC <<-CONFIG
		.lport_id = "${1}"
	CONFIG
	local BODY=$(echo "${MYSPEC}" | jq -r "$JQSPEC")
	printf "${BODY}"
}

ITEM="traceflows"
if [[ -n "${SPEC}" && -n "${PORT}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody "${PORT}")
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "${ITEM}.create") $(ccyan "<spec.traceflow> <port.id>")\n" 1>&2
fi
