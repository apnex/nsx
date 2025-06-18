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
valset "ports.id" "<ports.id>"

# run
run() {
	local SEGMENT_ID=${1}
	local PORT_ID=${2}
	URL=$(buildURL "${ITEM}")
	echo "mooo ${1}" 1>&2
	echo "mooo ${2}" 1>&2
	echo "mooo ${*}" 1>&2
	if [[ -n "${URL}" && -n "${SEGMENT_ID}" && -n "${PORT_ID}" ]]; then
		URL+="/${SEGMENT_ID}/ports/${PORT_ID}/mac-table"
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
        else
                echo "[$(corange "ERROR")]: params missing, specify [ $(ccyan "segment.id port.id") ]" 1>&2
                printf "[]" | jq --tab .
        fi
}

# driver + @args
driver "${@}"
