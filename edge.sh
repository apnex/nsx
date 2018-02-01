#!/bin/bash

#--powerOn \
ovftool \
--name=nsx-edge01 \
--deploymentOption=small \
--X:injectOvfEnv \
--X:logFile=ovftool.log \
--allowExtraConfig \
--datastore=ds-esx02 \
--net:"Network 0=VM Network" \
--net:"Network 1=VM Network" \
--net:"Network 2=VM Network" \
--net:"Network 3=VM Network" \
--acceptAllEulas \
--noSSLVerify \
--diskMode=thin \
--prop:nsx_ip_0=172.16.10.18 \
--prop:nsx_netmask_0=255.255.255.0 \
--prop:nsx_gateway_0=172.16.10.1 \
--prop:nsx_dns1_0=172.16.10.12 \
--prop:nsx_domain_0=lab \
--prop:nsx_ntp_0=8.8.8.8 \
--prop:nsx_isSSHEnabled=True \
--prop:nsx_allowSSHRootLogin=True \
--prop:nsx_passwd_0=VMware1! \
--prop:nsx_cli_passwd_0=VMware1! \
--prop:nsx_hostname=nsx-edge01 \
nsx-edge-2.1.0.0.0.7395502.ova \
vi://administrator@vsphere.local:VMware1%21@vcenter.lab/?ip=172.16.10.102
