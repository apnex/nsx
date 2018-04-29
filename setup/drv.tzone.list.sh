#!/bin/bash
source drv.core

function green {
        local STRING=${1}
        printf "${GREEN}${STRING}${NC}"
}

if [[ -n "${HOST}" ]]; then
	# get variables - if null do not proceed
	ITEM="transport-zones"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(green "INFO")]: nsx [$(green "list")] ${ITEM} - [$(green "$URL")]... " 1>&2
		rGet "${URL}"
	fi
fi
