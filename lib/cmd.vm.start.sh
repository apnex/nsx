#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## inputs - learn from drv?
INPUTS=()
INPUTS+=("vm.list")
#INPUTS+=("network.list")

## build context data
function join_by { local IFS="${1}"; shift; echo "${*}"; }
STRING=$(join_by "|" "${INPUTS[@]}")
CONTEXT=$("${WORKDIR}"/cmd.context.list.sh "type:${STRING}" json)

## build args from context
MYARGS=()
for ITEM in ${INPUTS[@]}; do
	MYARGS+=($("${WORKDIR}"/cmd.context.list.sh "type:${ITEM}" json | jq -r .[0].id))
done

## output
FORMAT=${1}
case "${FORMAT}" in
	plan)
		## build context table
		buildTable "${CONTEXT}"
	;;
	run)
		## call driver
		buildTable "${CONTEXT}"
		${WORKDIR}/drv.vm.start.sh "${MYARGS[@]}"
	;;
esac
