#### 1: Set up VCSA credentials
Modify the `vcsa-credentials` file to reflect the parameters for your lab.
I recommended using an FQDN of vcenter for the `hostname`.

```json
{
	"hostname": "vcenter.lab",
	"username": "administrator@vsphere.local",
	"password": "VMware1!",
	"domain": "lab"
}
```

#### 2: Set up NSXM credentials
Modify the `nsx-credentials` file to reflect the parameters for your lab. I recommended using an IP address for the `hostname`.
The `domain` property will be used in generating a certificate for the NSX Manager - i.e `*.lab` in this example.

```json
{
	"hostname": "172.16.10.15",
	"username": "admin",
	"password": "VMware1!VMware1!",
	"domain": "lab"
}
```

#### 3: Deploy NSX Manager and Controller OVAs
```shell
./deploy-manager.sh
./deploy-controller.sh
```

deploy nsx-t ovas - look at converting controller to a docker container to simplify deployment

#### 4: Prepare NSX VMs and power on
```shell
- create new vAPP 'nsx'
- add manager, controller to 'nsx' vAPP
- collapse startup order into single group
- modify memory and remove reservations
- power on vAPP
```

#### 5: Add vcenter.lab as a compute-manager to `nsx-manager`
```shell
./cmanager.list.sh
./cmanager.join.sh
./cmanager.list.sh
```

The compute-manager will take a couple of minutes to synchronise.
A successful join will show the version of vcenter under the `version` column.
A failed join will show `not-registered` in the `version` column.
If this occurs, it is likely vcenter had an old NSX extension already registered - view the `nsx-manager` UI to resolve.

#### 6: Create new `edge01` node 
```shell
./node.list.sh
./edge.create.sh edge01 172.16.10.18
./node.list.sh
```

This will inform `nsx-manager` to tell the `compute-manager` to create a new edge vm and join the node to the fabric.

#### 7: Add esx01.lab node to nsx manager
```shell
./node.list.sh
./node.join.sh 172.16.10.101
./node.list.sh
```

#### 8: Create transport-zones
```shell
./tzone.list.sh
./tzone.create.sh tz-tunnel hs-fabric OVERLAY
./tzone.create.sh tz-vlan hs-fabric VLAN
./tzone.list.sh
```

