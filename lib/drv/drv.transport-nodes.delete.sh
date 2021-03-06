#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
valset "transport-node" "<transport-nodes.id>"

# body
ID=${1}

# run
run() {
	URL=$(buildURL "${ITEM}")
	URL+="/${ID}"
	URL+="?force=true&unprepare_host=true"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxDelete "${URL}"
	fi
}

# driver
driver "${@}"
