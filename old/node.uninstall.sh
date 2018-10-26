#!/bin/bash
source drv.core
ID=${1}

if [[ -n "${ID}" ]]; then
	ssh root@${ID} <<-EOF
		vsipioctl clearallfilters
		/etc/init.d/netcpad stop
		esxcli software vib remove \
			-n nsx-aggservice \
			-n nsx-cli-libs \
			-n nsx-common-libs \
			-n nsx-da \
			-n nsx-esx-datapath \
			-n nsx-exporter \
			-n nsx-host \
			-n nsx-hyperbus \
			-n nsx-metrics-libs \
			-n nsx-mpa \
			-n nsx-nestdb-libs \
			-n nsx-nestdb \
			-n nsx-netcpa \
			-n nsx-opsagent \
			-n nsx-platform-client \
			-n nsx-profiling-libs \
			-n nsx-proxy \
			-n nsx-python-gevent \
			-n nsx-python-greenlet \
			-n nsx-python-logging \
			-n nsx-python-protobuf \
			-n nsx-rpc-libs \
			-n nsx-sfhc \
			-n nsx-shared-libs \
			-n nsxcli \
			--force
		esxcli software vib list | grep 'nsx\|epsec'
	EOF
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.uninstall") $(ccyan "<ip-address>")\n" 1>&2
fi
