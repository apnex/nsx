#!/bin/bash

CRT=$1
KEY=$2
DEVICECRT=$(cat $CRT | sed ':a;N;$!ba;s/\n/\\\\n/g')
DEVICEKEY=$(cat $KEY | sed ':a;N;$!ba;s/\n/\\\\n/g')

printf "Writing [certbody]\n" 1>&2
read -r -d '' CONFIG <<CONFIG
{
	"display_name": "$CRT",
	"pem_encoded": "$DEVICECRT",
	"private_key": "$DEVICEKEY"
}
CONFIG
printf "$CONFIG"
