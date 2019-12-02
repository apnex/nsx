#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
#INPUT=$(${WORKDIR}/drv.traceflows.observation.get.sh ${1})
INPUT=$(cat moo)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"resource_type": .resource_type,
		"transport_node_name": .transport_node_name,
		"transport_node_type": .transport_node_type,
		"component_name": .component_name,
		"component_type": .component_type,
		"component_detail": (
			if (.resource_type == "TraceflowObservationForwarded") and (.remote_ip_address | length) != 0 then
				"Remote: " + .remote_ip_address
			elif (.resource_type == "TraceflowObservationReceived") and (.remote_ip_address | length) != 0 then
				"Remote: " + .remote_ip_address
			elif (.resource_type == "TraceflowObservationForwardedLogical") and (.acl_rule_id | length) != 0 then
				"Rule-id: " + (.acl_rule_id | tostring)
			else "" end
		)
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

# build filter
FILTER=${2}
#FORMAT=${2}
PAYLOAD=$(filter "${PAYLOAD}" "${FILTER}")

## cache context data record
setContext "$PAYLOAD" "$TYPE"

## output
case "${FORMAT}" in
	json)
		## build payload json
		echo "${PAYLOAD}" | jq --tab .
	;;
	raw)
		## build input json
		echo "${INPUT}" | jq --tab .
	;;
	*)
		## build payload table
		buildTable "${PAYLOAD}"
	;;
esac
