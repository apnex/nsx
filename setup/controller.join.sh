#!/bin/bash

HOST=$1
NSXM=172.16.10.15
THUMBPRINT=$(./thumbprint.sh "$NSXM")
ssh admin@${HOST} <<EOF
	join management-plane ${NSXM} username admin password VMware1!VMware1! thumbprint ${THUMBPRINT}
	set control-cluster security-model shared-secret secret VMware1!
	initialize control-cluster
EOF
