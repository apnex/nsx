#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to mod.header
	WORKDIR=${BASH_REMATCH[1]}
	FILE=${BASH_REMATCH[2]}
	if [[ ${FILE} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/mod.core

# build filter
function cmd {
	local COMMAND=${1}
	case "${COMMAND}" in
		json)
			local PAYLOAD=$(run)
			echo "${PAYLOAD}" | jq --tab .
		;;
		watch)
			watch -c "${WORKDIR}/${FILE} 2>/dev/null"
		;;
		filter)
			local FILTER=${2}
			local PAYLOAD=$(filter "$(run)" "${FILTER}")
			buildTable "${PAYLOAD}"
		;;
		*)
			local PAYLOAD=$(run)
			buildTable "${PAYLOAD}"
		;;
	esac
	setContext "${PAYLOAD}" "${TYPE}"
}
