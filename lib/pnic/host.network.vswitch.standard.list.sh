#!/bin/bash
source drv.core
ID="${1}"

if [[ -n "${ID}" ]]; then
	sshpass -p 'VMware1!' ssh -T -o StrictHostKeyChecking=no root@"${ID}" <<-EOF
		esxcli network vswitch standard list
		esxcli network vswitch dvs vmware list
		#uplink remove -u vmnic1 -v vSwitch0
		#esxcfg-vmknic -l
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.interface.list") $(ccyan "<ip-address>")\n" 1>&2
fi
