#!/bin/bash
source drv.core

ID="${1}"
VSWITCH="${2}"
PGROUP="${3}"
VLAN="${4}"

if [[ -n "${ID}" && "${VSWITCH}" && "${PGROUP}" ]]; then
	if [[ -z "${VLAN}" ]]; then
		VLAN="0"
	fi
	sshpass -p 'VMware1!' ssh -T -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard portgroup add --vswitch-name "${VSWITCH}" --portgroup-name "${PGROUP}"
		esxcli network vswitch standard portgroup set --vlan-id "${VLAN}" --portgroup-name "${PGROUP}"
		esxcli network vswitch standard portgroup list
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.portgroup.add") $(ccyan "<ip-address> <vswitch-name> <pgroup-name> [ <vlan> ]")\n" 1>&2
fi
