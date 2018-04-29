#!/bin/bash
source drv.core

function green {
        local STRING=${1}
        printf "${GREEN}${STRING}${NC}"
}

if [[ -n "${HOST}" ]]; then
	# get variables - if null do not proceed
	ITEM="fabric/nodes"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		#logINFO
		printf "[$(green "INFO")]: nsx [$(green "list")] ${ITEM} - [$(green "$URL")]... " 1>&2
		rGet "${URL}"
	fi
fi
