#!/bin/bash
source drv.core

URL="https://$HOST/api/v1/fabric/compute-managers"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X GET \
-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
echo "$HTTPBODY"
