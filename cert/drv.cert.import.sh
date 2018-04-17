#!/bin/bash

BODY=$1
SESSION=$(./drv.session.sh 1>/dev/null)
HOST=$(cat nsx-credentials | jq -r .hostname)

URL="https://$HOST/api/v1/trust-management/certificates?action=import"
curl -k -b cookies.txt -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d @"$BODY" \
"$URL" 2>/dev/null
