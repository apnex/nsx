#!/bin/bash
source drv.core

# inputs
ID="${1}"

function makeBody {
	local IFS=$'\n'
	local RESPONSE=(${@})
	FINAL="[]"
	NODE="{}"
	for KEY in "${RESPONSE[@]:1}"; do
		if [[ $KEY =~ ([A-Za-z0-9][^:]*):[[:space:]]*(.*) ]]; then
			local ITEM=$(printf "%s\n" "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
			local VALUE=$(printf "%s\n" "${BASH_REMATCH[2]}")
			read -r -d '' RECORD <<-CONFIG
				{"${ITEM}": "${VALUE}"}
			CONFIG
			NODE="$(echo "${NODE}${RECORD}" | jq -s '. | add')"
		else
			FINAL="$(echo "${FINAL}[${NODE}]" | jq -s '. | add')"
		fi
	done
	FINAL="$(echo "${FINAL}[${NODE}]" | jq -s '. | add')"
	printf "${FINAL}" | jq --tab .
}

if [[ -n "${ID}" ]]; then
	RESPONSE=$(
		sshpass -p 'VMware1!' ssh -T -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
			esxcli network vswitch standard list
		EOF
	)
	makeBody "${RESPONSE}"
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.switch.list") $(ccyan "<ip-address>")\n" 1>&2
fi
