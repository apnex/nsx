#!/bin/bash
source drv.core

NODE=$1

URL="https://$HOST/api/v1/fabric/nodes/$NODE"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
-H "`grep X-XSRF-TOKEN headers.txt`" \
--data-urlencode "unprepare_host=false" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
