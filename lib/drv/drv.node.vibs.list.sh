#!/bin/bash
source mod.core
IPADDR="${1}"

function sshCmd {
	local COMMANDS="${1}"
	sshpass -p 'VMware1!' ssh root@"${IPADDR}" -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t "${COMMANDS}"
}

if [[ -n "${IPADDR}" ]]; then
	read -r -d '' COMMANDS <<-EOF
		esxcli software vib list | grep 'nsx'
	EOF
	RESPONSE=$(sshCmd "${COMMANDS}")
	printf "%s\n" "${RESPONSE}"
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.vibs.list") $(ccyan "<ip-address>")\n" 1>&2
fi
