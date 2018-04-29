#!/bin/bash

# export nsx configuration for offline cli use
echo "Exporting all known nsx specs.."
ITEM=$(./node.list.sh json)
echo "$ITEM" | jq --tab . > spec.node.json
ITEM=$(./tnode.list.sh json)
echo "$ITEM" | jq --tab . > spec.tnode.json
ITEM=$(./tzone.list.sh json)
echo "$ITEM" | jq --tab . > spec.tzone.json
ITEM=$(./pool.list.sh json)
echo "$ITEM" | jq --tab . > spec.pool.json
ITEM=$(./block.list.sh json)
echo "$ITEM" | jq --tab . > spec.block.json
ITEM=$(./profile.list.sh json)
echo "$ITEM" | jq --tab . > spec.profile.json
ITEM=$(./router.list.sh json)
echo "$ITEM" | jq --tab . > spec.router.json
ITEM=$(./switch.list.sh json)
echo "$ITEM" | jq --tab . > spec.switch.json
echo "Export completed"

