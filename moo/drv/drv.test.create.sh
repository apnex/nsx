#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

INPUTS=()
INPUTS+=("<transport-nodes.id>")
INPUTS+=("logical-switch.name")
INPUTS+=("<transport-zones.id>")
INPUTS+=("node.value")

run() {
	if [[ -n "${SWNAME}" && "${SWTZ}" ]]; then
		if [[ -n "${NSXHOST}" ]]; then
			BODY=$(makeBody)
			ITEM="logical-switches"
			URL=$(buildURL "${ITEM}")
			if [[ -n "${URL}" ]]; then
				printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
				nsxPost "${URL}" "${BODY}"
			fi
		fi
	else
		params
	fi
}

params() {
	#printf "%s\n" "<- params ->"
	for PARAM in ${INPUTS[@]}; do
		printf "%s\n" "${PARAM}"
	done
}

# switch
if [[ -n "${1}" ]]; then
	case "${1}" in
		list)
			params
		;;
		*)
			run
		;;
	esac
else
	run
fi
