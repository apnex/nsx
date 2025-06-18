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

valclear
valset "segments.id" "<segments.id>"

# run
run() {
        local ID=${1}
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" && -n "${ID}" ]]; then
		URL+="/${ID}/ports"
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
        else
                echo "[$(corange "ERROR")]: params missing, specify [ $(ccyan "segment.id") ]" 1>&2
                printf "[]" | jq --tab .
        fi
}

# driver
driver "${@}"
