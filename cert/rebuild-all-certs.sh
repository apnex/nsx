#!/bin/bash

DEVICE="nsxm"
DOMAIN=$(cat nsx-credentials | jq -r .domain)

# create and sign rootCA cert
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.pem -subj "/C=US/ST=CA/L=Palo Alto/O=vmware/OU=IT/CN=root.$DOMAIN"

# create and sign nsxm cert
openssl genrsa -out "$DEVICE".key 2048
openssl req -new -key "$DEVICE".key -out "$DEVICE".csr -subj "/C=US/ST=CA/L=Palo Alto/O=vmware/OU=IT/CN=*.$DOMAIN"
openssl x509 -req -in "$DEVICE".csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out "$DEVICE".pem -days 3650 -sha256

# validate cert and prepare certbody.json
openssl verify -verbose -CAfile rootCA.pem "$DEVICE".pem
./build-certbody.sh "$DEVICE".pem "$DEVICE".key > cert-import.json
