#!/bin/bash
source drv.core

VCSAHOST=$(cat vcsa-credentials | jq -r .hostname)
VCSAUSER=$(cat vcsa-credentials | jq -r .username)
VCSAPASS=$(cat vcsa-credentials | jq -r .password)
VCSAPRINT=$(./thumbprint.sh "$VCSAHOST" | sed -e :a -e 's/\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/\1:\2/;ta')

function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
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
	echo "${PAYLOAD}"
}

if [[ -n "${VCSAHOST}" && "${VCSAUSER}" && "${VCSAPASS}" && "${VCSAPRINT}" ]]; then
 	BODY=$(makeBody)
	URL="https://$HOST/api/v1/fabric/compute-managers"
	printf "NSX join CMANAGER [$VCSAHOST] - [$URL]... " 1>&2
	nsxPost "${URL}" "${BODY}"
else
	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tnode.create${LIGHTCYAN} <tnname> <nodeid>${NC}\n" 1>&2
fi

