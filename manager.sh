#!/bin/bash

#--powerOn \
ovftool \
--name=nsx-manager \
--X:injectOvfEnv \
--X:logFile=ovftool.log \
--allowExtraConfig \
--datastore=datastore1 \
--network="VM Network" \
--acceptAllEulas \
--noSSLVerify \
--diskMode=thin \
--prop:nsx_ip_0=172.16.10.15 \
--prop:nsx_netmask_0=255.255.255.0 \
--prop:nsx_gateway_0=172.16.10.1 \
--prop:nsx_dns1_0=172.16.10.12 \
--prop:nsx_domain_0=lab \
--prop:nsx_ntp_0=172.16.10.1 \
--prop:nsx_isSSHEnabled=True \
--prop:nsx_allowSSHRootLogin=True \
--prop:nsx_passwd_0="VMware1!VMware1!" \
--prop:nsx_cli_passwd_0="VMware1!VMware1!" \
--prop:nsx_hostname=nsxm \
nsx-unified-appliance-2.1.0.0.0.7395503.ova \
vi://administrator@vsphere.local:VMware1%21@vcenter.lab/?ip=172.16.10.11
