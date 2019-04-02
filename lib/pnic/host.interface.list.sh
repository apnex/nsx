#!/bin/bash
source drv.core
ID="${1}"

if [[ -n "${ID}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		#esxcli network ip interface list
		#esxcli network nic list
		esxcfg-vmknic -l
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.interface.list") $(ccyan "<ip-address>")\n" 1>&2
fi
