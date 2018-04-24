#!/bin/bash
source drv.core

VCSANAME=$1
VCSAPRINT=$(./thumbprint.sh "$VCSANAME")

URL="https://$HOST/api/v1/fabric/compute-managers"
printf "NSX join CMANAGER [$VCSANAME] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"server": "$VCSANAME",
	"origin_type": "vCenter",
	"credential" : {
		"credential_type" : "UsernamePasswordLoginCredential",
		"username": "administrator@vsphere.local",
		"password": "VMware1!VMware1!",
		"thumbprint": "$VCSAPRINT"
	}
}
CONFIG
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE" | jq --tab .
