#### 1: Set up sddc endpoints and parameters
Modify the `sddc.parameters` file to reflect the parameters for your lab accordingly.  
The `dns` field will be used to verify forward and reverse dns entries for each endpoint.  
The `domain` property will be used in generating a certificate for the NSX Manager - i.e `*.lab` in this example.  
For NSX certificate operations, the **vsp** endpoint is optional and not required.  
```json
{
	"dns": "172.16.0.1",
	"domain": "lab",
	"endpoints": [
		{
			"type": "nsx",
			"hostname": "nsxm01",
			"username": "admin",
			"password": "VMware1!VMware1!",
			"online": "true"
		},
		{
			"type": "vsp",
			"hostname": "vcenter",
			"username": "administrator@vsphere.local",
			"password": "VMware1!",
			"online": "true"
		}
	]
}
```

#### 2: Verify sddc status
This will perform a forward and reverse dns tests for each endpoint against the server @ `dns`.  
It will also perform a **ping** to the `hostname`.`domain` - if hostname is alphanumeric, or simply `hostname` if an IP address is specified.  
The SSL thumprint and certificate is also tested/extracted to indicate correct connectivity.  

<pre>
<b>sddc.status.sh</b>
</pre>

![sddc.status](asciicast/sddc.status.svg)

To view extended parameters (credentials / certificate) issue the following:  

<pre>
<b>sddc.status.sh json</b>
</pre>

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
<pre>
<b>cmanager.list.sh
cmanager.join.sh
cmanager.list.sh</b>
</pre>

The compute-manager will take a couple of minutes to synchronise.  
A successful join will show the version of vcenter under the `version` column.  
A failed join will show `not-registered` in the `version` column.  
If this occurs, it is likely vcenter had an old NSX extension already registered - view the `nsx-manager` UI to resolve.

#### 6: Create new `edge01` node  
This command creates a new VM edge node.  
A valid `compute-manager` must be joined to the NSX manager.

command usage: **edge.create `<node-name>` `<ip-address>`**
<pre>
<b>node.list.sh</b>
<b>edge.create.sh edge01 172.16.10.18</b>
<b>node.list.sh</b>
</pre>

This will inform `nsx-manager` to tell the `compute-manager` to create a new edge vm and join the node to the fabric.

#### 7: Add esx01.lab node to nsx manager
command usage: **node.join `<ip-address>`**
<pre>
<b>node.status.sh</b>
<b>node.join.sh 172.16.10.101</b>
<b>node.status.sh</b>
</pre>

#### 8: Create transport-zones  
command usage: **tzone.create `<tz-name>` `<hs-name>` `<type>`**
<pre>
<b>tzone.list.sh</b>
<b>tzone.create.sh tz-tunnel hs-fabric OVERLAY</b>
<b>tzone.create.sh tz-vlan hs-fabric VLAN</b>
<b>tzone.list.sh</b>
</pre>

#### 9: Create transport-nodes  
command usage: **tnode.create `<tn-name>` `<node-uuid>`**
<pre>
<b>tnode.status.sh</b>
<b>tnode.create.sh tn-edge01 f39ef916-f51a-4713-bb14-3aeb673d56ed</b>
<b>tzone.status.sh</b>
</pre>
