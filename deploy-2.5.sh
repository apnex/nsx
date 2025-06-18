#!/bin/bash
#	--prop:nsx_role="nsx-cloud-service-manager" \
ovftool \
	--name=nsx-manager \
	--X:injectOvfEnv \
	--X:logFile=ovftool.log \
	--allowExtraConfig \
	--datastore=ds-sddc \
	--network="pg-mgmt" \
	--acceptAllEulas \
	--noSSLVerify \
	--diskMode=thin \
	--prop:nsx_role="NSX Manager" \
	--prop:nsx_ip_0=172.16.10.15 \
	--prop:nsx_netmask_0=255.255.255.0 \
	--prop:nsx_gateway_0=172.16.10.1 \
	--prop:nsx_dns1_0=172.16.10.1 \
	--prop:nsx_domain_0=lab \
	--prop:nsx_ntp_0=172.16.10.1 \
	--prop:nsx_isSSHEnabled=True \
	--prop:nsx_allowSSHRootLogin=True \
	--prop:nsx_passwd_0="VMware1!VMware1!" \
	--prop:nsx_cli_passwd_0="VMware1!VMware1!" \
	--prop:nsx_hostname=nsx-manager \
nsx-unified-appliance-2.5.0.0.0.14663978.ova \
vi://administrator@vsphere.local:MyPassword@vcenter.lab/?ip=172.16.100.38

##
#vi://administrator@vsphere.local:VMware1%21@vcenter.lab/?ip=172.16.101.130

## buildweb links
BASEURL="http://web-server-hosting-ova"
MGROVA="${BASEURL}"/nsx-unified-appliance-2.4.0.0.0.12456291.ova
EDGOVA="${BASEURL}"/nsx-edge-2.4.0.0.0.12454265.ova

