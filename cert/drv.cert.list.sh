#!/bin/bash

HOST=$(cat nsx-credentials | jq -r .hostname)
SESSION=$(./drv.session.sh)
URL="https://$HOST/api/v1/trust-management/certificates"

curl -k -b cookies.txt -X GET \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null
