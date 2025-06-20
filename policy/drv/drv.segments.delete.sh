#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="infra/segments"
INPUTS=()
INPUTS+=("<segments.id>")

#valclear
#valset "segment" "<segments.id>"

# body
ID=${1}

# run
run() {
        URL=$(buildURL "${ITEM}")
        URL+="/${ID}"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxDelete "${URL}"
	fi
}

# driver
driver "${@}"
