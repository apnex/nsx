#!/bin/bash
source drv.core

ID="${1}"
VSWITCH="${2}"
PGROUP="${3}"

if [[ -n "${ID}" && "${VSWITCH}" && "${PGROUP}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard portgroup remove --vswitch-name "${VSWITCH}" --portgroup-name "${PGROUP}"
		esxcli network vswitch standard portgroup list
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.portgroup.remove") $(ccyan "<ip-address> <vswitch-name> <pgroup-name>")\n" 1>&2
fi
