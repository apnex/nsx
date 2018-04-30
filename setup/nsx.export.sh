#!/bin/bash

# export nsx configuration for offline cli use
echo "Exporting all known nsx specs.."

read -r -d '' SPECS <<-CONFIG
	"drv.node.list.sh"
	"drv.tnode.list.sh"
	"drv.tzone.list.sh"
	"drv.pool.list.sh"
	"drv.block.list.sh"
	"drv.profile.list.sh"
	"drv.router.list.sh"
	"drv.switch.list.sh"
	"drv.cmanager.list.sh"
CONFIG
for key in $(echo ${SPECS}); do
	RUNFILE="./${key}"
	eval ${RUNFILE} 1>/dev/null
done

echo "Export completed"

