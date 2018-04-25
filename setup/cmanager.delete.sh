#!/bin/bash
source drv.core

ID=$1
if [ -n "$ID" ]; then
	URL="https://$HOST/api/v1/fabric/compute-managers/$ID"
	printf "NSX DELETE compute-manager [$ID] - [$URL]... " 1>&2
	RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X DELETE \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
else
	echo "Please provide a [compute-manager] ID"
fi
