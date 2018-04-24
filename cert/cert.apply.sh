#!/bin/bash

PAYLOAD=$(./drv.cert.apply.sh $1)
echo "$PAYLOAD" | jq --tab .
