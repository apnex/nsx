#!/bin/bash

HOST=$1
NSXM=$(cat nsx-credentials | jq -r .hostname)
THUMBPRINT=$(./thumbprint.sh "$NSXM")

ssh root@${HOST} <<EOF
	vsipioctl clearallfilters
	/etc/init.d/netcpad stop
	esxcli software vib remove \
		-n nsx-shared-libs \
		-n nsx-common-libs \
		-n nsx-metrics-libs \
		-n nsx-rpc-libs \
		-n nsx-nestdb-libs \
		-n nsxa \
		-n nsx-lldp \
		-n nsx-da \
		-n nsx-exporter \
		-n nsx-aggservice \
		-n nsxcli \
		-n nsx-python-gevent \
		-n nsx-python-greenlet \
		-n nsx-python-protobuf \
		-n nsx-sfhc \
		-n nsx-netcpa \
		-n nsx-mpa \
		-n nsx-esx-datapath \
		-n nsx-host \
		-n nsx-support-bundle-client \
		-n nsx-nestdb \
		-n nsx-platform-client \
		-n nsx-hyperbus \
		-n nsx-ctxteng \
		-n epsec-mux \
		--force
	esxcli software vib list | grep 'nsx\|epsec'
EOF
