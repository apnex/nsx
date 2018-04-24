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
The `domain` property will be used in generating a certificate for the NSX Manager - i.e `*.corp.local` in this example.

```json
{
	"hostname": "172.16.10.15",
	"username": "admin",
	"password": "VMware1!VMware1!",
	"domain": "corp.local"
}
```

#### 3: Deploy NSX Manager and Controller OVAs
```
./deploy-manager.sh
./deploy-controller.sh
```

##### deploy nsx-t ovas
##### look at converting controller to a docker container to simplify deployment

#### 4: Prepare NSX VMs and power on
- create new vAPP 'nsx'
- add manager, controller, edge to 'nsx' vAPP
- collapse startup order into single group
- modify memory and reservations
- power on vAPP

# add esx01.lab node to nsx manager
./node.join.sh 172.16.10.101
./node.list.sh

# add vcenter.lab as a compute manager to NSXM
- work out how to automated compute manager registration
./cmanager.list.sh
./cmanager.create.sh vcenter.lab
./cmanager.list.sh

# create a new edge VM
./node.list.sh
./edge.create.sh edge01.lab 172.16.10.18
./node.list.sh

# create transport-zones
./tzone.list.sh
./tzone.create.sh tz-tunnel hs-fabric OVERLAY
./tzone.create.sh tz-vlan hs-fabric VLAN
./tzone.list.sh


