#!/bin/bash
source drv.core

# inputs
ID="${1}"

if [[ -n "${ID}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard portgroup list
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "host.portgroup.list") $(ccyan "<ip-address>")\n" 1>&2
fi
