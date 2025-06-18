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

function buildMacTable {
        local SEGMENT=${1}

	## get all ports for segment
	PORTLIST=$(${WORKDIR}/drv.segments.ports.list.sh "${SEGMENT}")
	PORTS=$(echo $PORTLIST | jq -r '.results')

	# prepare batch request payload
        read -r -d '' BATCHSPEC <<-CONFIG
		{
			"method": "GET",
			"uri": "/v1/\(.path)/mac-table"
		}
	CONFIG
	BATCHLIST=$(echo "${PORTS}" | jq -r "{ \"requests\": map(${BATCHSPEC}) }")

	# make batch call, get result
	PORTMACLIST=$(${WORKDIR}/drv.batch.sh "${BATCHLIST}")

	# make array of mac-table sets per port
	MACRESULT=$(echo ${PORTMACLIST} | jq -r '.results | map(.body)')

	# combine port objects with mac-table objects
	read -r -d '' MERGESPEC <<-CONFIG
		map(to_entries) |
		flatten |
		group_by(.key) |
		map( # foreach port + mactable pair, construct object
			.[1].value
			+
			{ "port_id": .[0].value.id }
		)
	CONFIG
	COMBINEDLIST=$(echo ${PORTS} ${MACRESULT} | jq -s "${MERGESPEC}")

	read -r -d '' FLATTENSPEC <<-CONFIG
		map (
			.results[]
			+
			{
				"port_id": .port_id,
				"transport_node_id": .transport_node_id
			}
		)
	CONFIG
	FLATTENEDLIST=$(echo ${COMBINEDLIST} | jq -r "${FLATTENSPEC}")

	printf "%s\n" "${FLATTENEDLIST}"
}

run() {
	local ID=${1}
	if [[ -n ${ID} ]]; then
		MACLIST=$(buildMacTable "${ID}")
		printf "${MACLIST}" | jq --tab .
	else
		echo "[$(corange "ERROR")]: params missing, specify [ $(ccyan "segment.id") ]" 1>&2
		printf "[]" | jq --tab .
	fi
}

# driver + @args
driver "${@}"
