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
		printf "%s\n" "--[ dvport 25 ]--"
		netdbg vswitch mac-table port get --dvs-alias fabric --dvport 25 2>/dev/null
		printf "%s\n" "--[ dvport 26 ]--"
		netdbg vswitch mac-table port get --dvs-alias fabric --dvport 26 2>/dev/null
		printf "%s\n" "--[ dvport 27 ]--"
		netdbg vswitch mac-table port get --dvs-alias fabric --dvport 27 2>/dev/null
		printf "%s\n" "--[ dvport 28 ]--"
		netdbg vswitch mac-table port get --dvs-alias fabric --dvport 28 2>/dev/null
	EOF
	sshCmd "${COMMANDS}"
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.netdbg.instance.list") $(ccyan "<ip-address>")\n" 1>&2
fi
