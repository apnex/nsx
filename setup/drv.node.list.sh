#!/bin/bash
source ./drv.core

# get the nodes
URL="https://$HOST/api/v1/fabric/nodes"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X GET \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
echo "$HTTPBODY"

# get the status
URL="https://$HOST/api/v1/fabric/nodes/<node-id>/status"
#printf "Retrieving [$URL]... " 1>&2
#RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X GET \
#-H "`grep X-XSRF-TOKEN headers.txt`" \
#-H "Content-Type: application/json" \
#"$URL" 2>/dev/null)
#isSuccess "$RESPONSE"
#echo "$HTTPBODY"

