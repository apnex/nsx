#!/bin/bash

RAW=$1
if [[ -n "$RAW" ]]; then
	# get the status
	URL="https://172.16.10.15/api/v1/fabric/nodes/${RAW}/status"
	printf "Retrieving [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X GET \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	echo "$RESPONSE"
else
	echo "Please enter an ID"
fi

