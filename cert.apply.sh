#!/bin/bash

SESSION=$(./drv.session.sh)
PAYLOAD=$(./drv.cert.apply.sh $1)
echo "$PAYLOAD" | jq --tab .
