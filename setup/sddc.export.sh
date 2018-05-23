#!/bin/bash
source drv.core
source drv.nsx.client

# export nsx configuration for offline cli use
echo "Exporting all known nsx specs.."

if [[ "${NSXONLINE}" == "true" ]]; then
	printf "[$(cgreen "INFO")]: nsx [$(cgreen "online")]... [$(ccyan "TRUE")] - SUCCESS\n" 1>&2
	rm ./state/*json
else
	printf "[$(corange "WARN")]: nsx [$(cgreen "online")]... [$(ccyan "FALSE")] - SUCCESS\n" 1>&2
fi
read -r -d '' SPECS <<-CONFIG
	"drv.openapi.list.sh"
	"drv.node.status.sh"
	"drv.cmanager.list.sh"
	"drv.tnode.list.sh"
	"drv.tzone.list.sh"
	"drv.pool.list.sh"
	"drv.block.list.sh"
	"drv.hostswitch-profile.list.sh"
	"drv.cluster-profile.list.sh"
	"drv.edge-cluster.list.sh"
	"drv.router.list.sh"
	"drv.router-port.list.sh"
	"drv.switch.list.sh"
CONFIG
for key in $(echo ${SPECS}); do
	RUNFILE="./${key}"
	eval ${RUNFILE} 1>/dev/null
done

echo "Export completed"

