#!/bin/bash
source ./drv.source

ID=$1
if [ -n "$ID" ]; then
	SESSION=$(./drv.session.sh)
	URL="https://$HOST/api/v1/pools/ip-pools/$ID"
	printf "Retrieving [$URL]... " 1>&2
	RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	--data-urlencode "force=true" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
else
	echo "Please specify a pool ID"
fi

