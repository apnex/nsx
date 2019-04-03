#!/bin/bash
source drv.core

# inputs
ID="${1}"

function sshCmd {
	local COMMANDS="${1}"
	sshpass -p 'VMware1!' ssh root@"${ID}" -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t "${COMMANDS}"
}

if [[ -n "${ID}" ]]; then
	read -r -d '' COMMANDS <<-EOF
		netdbg vswitch instance list
	EOF
	sshCmd "${COMMANDS}"
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.netdbg.instance.list") $(ccyan "<ip-address>")\n" 1>&2
fi
