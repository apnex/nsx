#!/bin/bash
source drv.core

ID="${1}"
VSWITCH="${2}"

if [[ -n "${ID}" && "${VSWITCH}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard remove --vswitch-name "${VSWITCH}"
		esxcli network vswitch standard list
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.interface.list") $(ccyan "<ip-address> <vswitch-name>")\n" 1>&2
fi
