#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to mod.header
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/mod.core

# build filter
function run {
	PAYLOAD=${1}
	FILTER=${2}
	FORMAT=${3}
	PAYLOAD=$(filter "${PAYLOAD}" "${FILTER}")

	## cache context data record
	setContext "$PAYLOAD" "$TYPE"

	## output
	case "${FORMAT}" in
		json)
			## build payload json
			echo "${PAYLOAD}" | jq --tab .
		;;
		*)
			## build payload table
			buildTable "${PAYLOAD}"
		;;
	esac
}
