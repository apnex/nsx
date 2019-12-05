#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	## input driver
	INPUT=$(${WORKDIR}/drv.traceflows.list.sh)

	## build record structure
	read -r -d '' INPUTSPEC <<-CONFIG
		.results | if (. != null) then map({
			"id": .id,
			"operation_state": .operation_state,
			"request_status": .request_status
		}) else "" end
	CONFIG

	# output
	PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")
	printf "${PAYLOAD}"
}

## cmd
cmd "${@}"
