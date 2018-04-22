#!/bin/bash
source ./drv.core

NODEID=$1

#URL="https://$HOST/api/v1/fabric/nodes/$1?unprepare_host=false"
#printf "Retrieving [$URL]... " 1>&2
#RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X DELETE \
#-H "`grep X-XSRF-TOKEN headers.txt`" \
#"$URL")
#isSuccess "$RESPONSE"

URL="https://$HOST/api/v1/fabric/nodes/$NODEID"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
-H "`grep X-XSRF-TOKEN headers.txt`" \
--data-urlencode "unprepare_host=false" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
