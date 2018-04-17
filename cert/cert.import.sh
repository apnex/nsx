#!/bin/bash

PAYLOAD=$(./drv.cert.import.sh "cert-import.json")
echo "$PAYLOAD" | jq --tab .
