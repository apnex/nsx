#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.mgmt.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="infra/sites/default/enforcement-points/default/host-transport-nodes"
INPUTS=()

# run
run() {
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
}

# driver
driver "${@}"
