#!/bin/bash

CERTID=$1
HOST=$(cat nsx-credentials | jq -r .hostname)

URL="https://$HOST/api/v1/node/services/http?action=apply_certificate&certificate_id=$CERTID"
curl -k -b cookies.txt -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null
