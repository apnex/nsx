#!/bin/bash

./drv.transport-nodes.list.sh | jq --tab '.results | map(select(.node_id=="'${1}'")) | .[0]'
