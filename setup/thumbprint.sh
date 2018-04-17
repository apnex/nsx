#!/bin/bash

PAYLOAD=$(./drv.thumbprint.sh "$1":443 "thumbprint")
echo "$PAYLOAD"
