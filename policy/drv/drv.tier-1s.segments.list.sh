#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="infra/tier-1s"
INPUTS=()
INPUTS+=("<tier-1s.id>")

valclear
valset "tier-1s.id" "<tier-1s.id>"

# body
ID=${1}

# run
run() {
	URL=$(buildURL "${ITEM}")
	URL+="/${ID}/locale-services/7bc1bc9e-e508-4f13-b537-91e8b12071b7/interfaces"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
}

# driver
driver "${@}"
