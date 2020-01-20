#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
STATEDIR="${WORKDIR}/state" ## offload to core?
if [ ! -d ${STATEDIR} ]; then
	mkdir ${STATEDIR}
fi
source ${WORKDIR}/drv.core

## check context
ID=${1}
ITEM="vm.list"
if [ -z "${ID}" ]; then
	CONTEXT="${WORKDIR}/state/ctx.${ITEM}.json"
	if [ -f "${CONTEXT}" ]; then
		ID=$(cat "${CONTEXT}" | jq -r ".id")
	fi
fi
#echo $ID

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	inputs |
	{
		"object": . ,
		"filename": input_filename,
		"linenumber": input_line_number
	}
CONFIG
read -r -d '' JQSPEC <<-CONFIG
	. | map({
		"id": .object.id,
		"name": .object.name,
		"type": (
			.filename
			| sub("^.+/ctx.";"")
			| sub(".json$";"")
		)
	})
CONFIG

# merge and output json
STATE="${STATEDIR}/vsp.context.list.json"
RESULT=$(jq -n "$INPUTSPEC" "${STATEDIR}"/ctx.*.json | jq -s "${JQSPEC}")
printf "%s\n" "${RESULT}" | jq --tab . >"${STATE}"
printf "%s\n" "${RESULT}" | jq --tab .
