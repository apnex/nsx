#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="infra?filter=Type-.*"
#ITEM="infra?type_filter=ChildSegmentPort"
#ITEM="infra?base_path=/infra/segments/seg-givr-palo-vlan100&type_filter=SegmentPort"
INPUTS=()

# run
run() {
	#BODY=$(<spec.delete.seg.json)
	#printf "%s\n" "${BODY}"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
