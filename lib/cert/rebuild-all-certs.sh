#!/bin/bash
source drv.core
source drv.nsx.client

DEVICE="nsxm"
DIR="state"

function makeBody {
	local CRT=${1}
	local KEY=${2}
	local DEVICECRT=$(cat "${DIR}"/$CRT | sed ':a;N;$!ba;s/\n/\\n/g')
	local DEVICEKEY=$(cat "${DIR}"/$KEY | sed ':a;N;$!ba;s/\n/\\n/g')
	printf "Writing [$DIR/cert-import.json]\n" 1>&2
	read -r -d '' SPEC <<-CONFIG
	{
		"display_name": "$CRT",
		"pem_encoded": "$DEVICECRT",
		"private_key": "$DEVICEKEY"
	}
	CONFIG
	printf "%s\n" "$SPEC"
}

# create and sign rootCA cert
openssl genrsa -out "${DIR}"/rootCA.key 2048
openssl req -x509 -new -nodes -key "${DIR}"/rootCA.key -sha256 -days 3650 -out "${DIR}"/rootCA.pem -subj "/C=US/ST=CA/L=Palo Alto/O=vmware/OU=IT/CN=root.$DOMAIN"

# create and sign nsxm cert
openssl genrsa -out "${DIR}"/"$DEVICE".key 2048
openssl req -new -key "${DIR}"/"$DEVICE".key -out "${DIR}"/"$DEVICE".csr -subj "/C=US/ST=CA/L=Palo Alto/O=vmware/OU=IT/CN=*.$DOMAIN"
openssl x509 -req -in "${DIR}"/"$DEVICE".csr -CA "${DIR}"/rootCA.pem -CAkey "${DIR}"/rootCA.key -CAcreateserial -out "${DIR}"/"$DEVICE".pem -days 3650 -sha256

# validate cert and prepare certbody.json
openssl verify -verbose -CAfile "${DIR}"/rootCA.pem "${DIR}"/"$DEVICE".pem
makeBody "$DEVICE".pem "$DEVICE".key >"${DIR}"/cert-import.json
