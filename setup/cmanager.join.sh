#!/bin/bash
source drv.core

VCSAHOST=$(cat vcsa-credentials | jq -r .hostname)
VCSAUSER=$(cat vcsa-credentials | jq -r .username)
VCSAPASS=$(cat vcsa-credentials | jq -r .password)
VCSAPRINT=$(./thumbprint.sh "$VCSAHOST" | sed -e :a -e 's/\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/\1:\2/;ta')

URL="https://$HOST/api/v1/fabric/compute-managers"
printf "NSX join CMANAGER [$VCSAHOST] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"server": "$VCSAHOST",
	"display_name": "$VCSAHOST",
	"origin_type": "vCenter",
	"credential" : {
		"credential_type" : "UsernamePasswordLoginCredential",
		"username": "$VCSAUSER",
		"password": "$VCSAPASS",
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
