#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
#ITEM="infra?filter=Type-Tier1"
#ITEM="infra?filter=Type-Segment"
ITEM="infra"
INPUTS=()

# run
run() {
	BODY=$(<spec.seg.json)
	printf "%s\n" "${BODY}"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxPatch "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
