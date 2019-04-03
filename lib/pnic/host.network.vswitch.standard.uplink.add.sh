#!/bin/bash
source drv.core

ID="${1}"
NIC="${2}"
SWITCH="${3}"

if [[ -n "${ID}" && "${NIC}" && "${SWITCH}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard uplink add -u "${NIC}" -v "${SWITCH}"
		esxcli network vswitch standard list
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.interface.list") $(ccyan "<ip-address> <nic> <vswitch>")\n" 1>&2
fi
