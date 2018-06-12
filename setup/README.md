#### 1: Deploy NSX Manager OVAs
First, download the NSX manager from **my.vmware.com** - either via a browser or use the `myvmw` CLI utility: <https://github.com/apnex/myvmw>  
The following steps use the file `nsx-unified-appliance-2.2.0.0.0.8680778.ova`  
Next, import the OVA into vCenter - either manually through the UI or using ovftool as follows  
(edit parameters as appropriate):  
```shell
ovftool \
	--name=nsx-manager \
	--X:injectOvfEnv \
	--X:logFile=ovftool.log \
	--allowExtraConfig \
	--datastore=datastore1 \
	--network="pg-mgmt" \
	--acceptAllEulas \
	--noSSLVerify \
	--diskMode=thin \
	--prop:nsx_ip_0=172.16.10.15 \
	--prop:nsx_netmask_0=255.255.255.0 \
	--prop:nsx_gateway_0=172.16.10.1 \
	--prop:nsx_dns1_0=172.16.0.1 \
	--prop:nsx_domain_0=lab \
	--prop:nsx_ntp_0=172.16.0.1 \
	--prop:nsx_isSSHEnabled=True \
	--prop:nsx_allowSSHRootLogin=True \
	--prop:nsx_passwd_0="VMware1!VMware1!" \
	--prop:nsx_cli_passwd_0="VMware1!VMware1!" \
	--prop:nsx_hostname=nsx-manager \
	nsx-unified-appliance-2.2.0.0.0.8680778.ova \
	vi://administrator@vsphere.local:VMware1%21@vcenter.lab/?ip=172.16.0.11
```

This will provision a powered-off NSX manager VM. Modify any memory reservations as required and power on.  

#### 2: Set up sddc endpoints and parameters
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

#### 3: Verify sddc status
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

#### 4: Add vcenter.lab as a compute-manager to `nsx-manager`  
<pre>
<b>cmanager.list.sh
cmanager.join.sh
cmanager.list.sh</b>
</pre>

![cmanager.join](asciicast/cmanager.join.svg)

The compute-manager will take a couple of minutes to synchronise.  
A successful join will show the version of vcenter under the `version` column.  
A failed join will show `not-registered` in the `version` column.  
If this occurs, it is likely vcenter had an old NSX extension already registered - view the `nsx-manager` UI to resolve.

#### 5: Provision a new NSX controller
This command creates a new controller node.  
A valid `compute-manager` must be joined to the NSX manager.  

command usage: **controller.create `<shared-secret>`**
<pre>
<b>controller.list.sh
controller.create.sh VMware1!
controller.list.sh</b>
</pre>

![controller.create](asciicast/controller.create.svg)

#### 6: Add esx01.lab node to nsx manager
command usage: **node.join `<ip-address>`**
<pre>
<b>node.status.sh</b>
<b>node.join.sh 172.16.10.101</b>
<b>node.status.sh</b>
</pre>

#### 7: Create new `edge01` node  
This command creates a new VM edge node.  
A valid `compute-manager` must be joined to the NSX manager.

command usage: **edge.create `<node-name>` `<ip-address>`**
<pre>
<b>node.list.sh</b>
<b>edge.create.sh edge01 172.16.10.18</b>
<b>node.list.sh</b>
</pre>

This will inform `nsx-manager` to tell the `compute-manager` to create a new edge vm and join the node to the fabric.

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
