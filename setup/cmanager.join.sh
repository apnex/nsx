#!/bin/bash
source drv.core
source drv.nsx.client
source drv.vsp.client

## temp - move back to drv core - needed for : (colon) separation of {2} values
PAYLOAD=$(echo -n | openssl s_client -connect "${VSPHOST}":443 2>/dev/null)
PRINT=$(echo "$PAYLOAD" | openssl x509 -noout -fingerprint -sha256)
REGEX='^(.*)=(([0-9A-Fa-f]{2}[:])+([0-9A-Fa-f]{2}))$'
if [[ $PRINT =~ $REGEX ]]; then
	TYPE=${BASH_REMATCH[1]}
	VSPPRINT=${BASH_REMATCH[2]}
fi

function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"server": "$VSPHOST",
		"display_name": "$VSPHOST",
		"origin_type": "vCenter",
		"credential" : {
			"credential_type" : "UsernamePasswordLoginCredential",
			"username": "$VSPUSER",
			"password": "$VSPPASS",
			"thumbprint": "$VSPPRINT"
		}
	}
	CONFIG
	echo "${PAYLOAD}"
}

if [[ -n "${VSPHOST}" && "${VSPUSER}" && "${VSPPASS}" && "${VSPPRINT}" ]]; then
 	BODY=$(makeBody)
	URL="https://$NSXHOST/api/v1/fabric/compute-managers"
	printf "[$(cgreen "INFO")]: nsx [$(cgreen "join")] compute-manager [$(cgreen "$VSPHOST")] [$(cgreen "$URL")]... " 1>&2
	nsxPost "${URL}" "${BODY}"
else
	printf "[$(cgreen "ERROR")]: Command usage: $(cgreen "cmanager.join") $(ccyan "<tnname> <nodeid>")\n" 1>&2
fi

