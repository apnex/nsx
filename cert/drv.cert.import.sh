#!/bin/bash
source drv.core

BODY=$1

URL="https://$HOST/api/v1/trust-management/certificates?action=import"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
-H "Content-Type: application/json" \
-d @"$BODY" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
echo "$HTTPBODY"
