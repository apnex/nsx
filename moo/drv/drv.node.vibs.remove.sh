#!/bin/bash
source mod.core
IPADDR="${1}"

function sshCmd {
	local COMMANDS="${1}"
	sshpass -p 'VMware1!' ssh root@"${IPADDR}" -o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t "${COMMANDS}"
}

#		nsxcli -c detach management-plane nsxm01.lab username admin password VMware1!VMware1! thumbprint 088f2486e9297d999ad61be881496131c97e67255db26a04e6ec2b5d3e4b46c4
if [[ -n "${IPADDR}" ]]; then
	read -r -d '' COMMANDS <<-EOF
		vsipioctl clearallfilters -Override
		/etc/init.d/netcpad stop
		nsxcli -c del nsx
		esxcli software vib list | grep 'nsx'
	EOF
	RESPONSE=$(sshCmd "${COMMANDS}")
	printf "%s\n" "${RESPONSE}"
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.vibs.remove") $(ccyan "<ip-address>")\n" 1>&2
fi
