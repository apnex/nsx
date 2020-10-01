#!/bin/bash
if [[ $(realpath $0) =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
STATEDIR=${WORKDIR}/drv/state
JQDIR=${WORKDIR}/tpl
source ${WORKDIR}/drv/mod.core

# build filter
function cmd {
	local FILTER
	local COMMAND=${1}
	case "${COMMAND}" in
		params)
			$(drv "${TYPE}") "params" # link to drv
		;;
		keys)
			$(drv "${TYPE}") "keys" # link to drv
		;;
		watch)
			watch -t -c -n 3 "${WORKDIR}/${FILE} 2>/dev/null"
		;;
		json)
			local PAYLOAD=$(payload)
			echo "${PAYLOAD}" | jq --tab .
		;;
		raw)
			local PAYLOAD=$(payload)
			echo "${PAYLOAD}"
		;;
		filter)
			FILTER=${2}
			dofilter "${@}"
		;;
		*)
			template "${@}"
		;;
	esac
}

function buildTable {
	local INPUT="${1}" # change first entry to color, separate from data body
	read -r -d '' JQTABLE <<-CONFIG
		if (.[0]?) then
			[(
				[.[0] | to_entries[] | .key | ascii_upcase]
			),(
				.[] | [to_entries[] | .value]
			)]
		else . end
	CONFIG
	local HEADER="1"
	echo "$INPUT" | jq -r "$JQTABLE | .[] | @tsv" | column -t -s $'\t' | while read -r LINE; do
		if [[ -n $HEADER ]]; then
			printf "${CYAN}${LINE}${NC}\n"
			HEADER=""
		else
			printf "$LINE\n";
		fi
	done
}

function dofilter {
	local PARAMS=(${@})
	local INPUT=$(eval $(drv "${TYPE}")) # link to drv

	local TEMPLATE="${JQDIR}/tpl.${TYPE}.jq"
	if [[ -f "${TEMPLATE}" ]]; then
		local TPLJSON=$(echo "${INPUT}" | jq -f ${JQDIR}/tpl.${TYPE}.jq)
		if [[ -n ${FILTER} ]]; then
			local PAYLOAD=$(filter "${TPLJSON}" "${FILTER}")
			#setContext "${PAYLOAD}" "${TYPE}"
			buildTable "${PAYLOAD}"
		else
			#setContext "${TPLJSON}" "${TYPE}"
			buildTable "${TPLJSON}"
		fi
	else
		echo "[$(corange "WARN")]: template [$(cgreen "${TEMPLATE}")] not found" 1>&2
		echo "${INPUT}" | jq --tab .
	fi
}

function template {
	local PARAMS=(${@})
	local INPUT=$($(drv "${TYPE}") ${PARAMS}) # link to drv
	local TEMPLATE="${JQDIR}/tpl.${TYPE}.jq"
	if [[ -f "${TEMPLATE}" ]]; then
		local PAYLOAD=$(echo "${INPUT}" | jq -f ${JQDIR}/tpl.${TYPE}.jq)
		#setContext "${PAYLOAD}" "${TYPE}"
		buildTable "${PAYLOAD}"
	else
		echo "[$(corange "WARN")]: template [$(cgreen "${TEMPLATE}")] not found" 1>&2
		echo "${INPUT}" | jq --tab .
	fi
}

function payload {
	local PARAMS=(${@})
	local PAYLOAD=$(eval $(drv "${TYPE}") ${PARAMS}) # link to drv
	printf "%s" "${PAYLOAD}"
}

function drv {
	local DRIVER=${1}
	printf "${WORKDIR}/drv/drv.${DRIVER}.sh"
}
