### WHAT
### Prepare Hosts and Networking

### Host and Clusters

#### Create Datacenter
- Create a new **datacenter** with name `sddc`

#### Hosts

| type	| fqdn		| ip		| username	| password	|
| ---	| ---		| ---		| :---:		| :---:		|
| host	| `esx21.lab01`	| 10.30.0.121	| root		| VMware1!SDDC	|
| host	| `esx22.lab01`	| 10.30.0.122	| root		| VMware1!SDDC	|
| host	| `esx23.lab01`	| 10.30.0.123	| root		| VMware1!SDDC	|
| host	| `esx24.lab01`	| 10.30.0.124	| root		| VMware1!SDDC	|

#### Starting structure
- Create a new **datacenter** with name `sddc`
<pre>
vcenter.lab02
  +- sddc
      +- sddc
:&#2521:
:u2521:
</pre>
:&#2521:
:u2521:

### Licenses
Apply correct vCenter and vSphere licenses to **Assets**
- 4x ESX nodes
- vCenter

### Networking
Create a new **vds** with name `fabric`

| type		| name		| version	| default portgroup	|
| ---		| ---		| :---:		| :---:			|
| vds		| `fabric`	| 7.0.0		| -			|

Untick the **Create default portgroup** tickbox, as it is not required.  
Once created, edit the switch settings and set **MTU** to `9000`.

#### Portgroup configuration
Create a base portgroups for switch `fabric`  
Name format is: `pg-<function>`  
**Where:**  
- `<function>` is one of [`mgmt`,`vmotion`,`uplink`]

| type		| name		| VLAN Type	| VLAN ID	|
| ---		| ---		| :---:		| :---:		|
| portgroup	| `pg-mgmt`	| none		| -		|
| portgroup	| `pg-vmotion`	| VLAN		| 302		|
| portgroup	| `pg-uplink`	| VLAN		| 5		|

#### Add hosts to switch `fabric`
- Right-click `fabric` and enter `Add and Manage Hosts`  
- Select `Add Hosts`, and select all available `esxXX` nodes.  

Under `Manage Physical Adapters`
- Select `vmnic0` on first esx host, and click `Assign Uplink`
- Ensure `Uplink 1` is selected, and enable `Apply this uplink assignment to the rest of the hosts` checkbox
- Select `vmnic1` on first esx host, and click `Assign Uplink`
- Ensure `Uplink 2` is selected, and enable `Apply this uplink assignment to the rest of the hosts` checkbox
- Click **OK**

Under `Manage VMKernel Adapters`
- Select `vmk0` on first esx host, and click `Assign Port Group`
- Select `pg-mgmt` and enable `Apply this portgroup assignment to the rest of the hosts` checkbox
- Click **OK**

Finish Network Configuration
- Click **NEXT**
- Click **NEXT**
- Click **FINISH**

#### Verify Host Physical Adapters
- Go to `Hosts and Clusters`
- Select the first esx host
- Select `Configure` -> `Physical Adapters`
- Verify that both physical nics are attached to switch `fabric`

| device	| acutal speed	| configured speed	| switch	| MAC address		|
| ---		| ---:		| ---:			| :---		| :---			|
| `vmnic0`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:01	|
| `vmnic1`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:02	|

#### Configure vMotion Kernel Adapters
- Select `Configure` -> `VMKernel Adapters`
- For each esx host, select `Add Networking` and configure as follows:

| device	| acutal speed	| configured speed	| switch	| MAC address		|
| ---		| ---:		| ---:			| :---		| :---			|
| `vmnic0`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:01	|
| `vmnic1`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:02	|

Under `Select Connection Type`
- Select `VMKernel Network Adapter`
- Click **NEXT**

Under `Select Target Device`
- Select `Existing Network`
- Click **BROWSE**
- Select `pg-vmotion`
- Click **OK**
- Click **NEXT**

Under `Port Properties`
- Select `TCP/IP Stack` -> `vMotion`
- Click **NEXT**

Under `IPv4 Settings`
- Select `Use static IPv4 settings`
- Enter `IPv4 Address` -> `10.30.2.111`
- Enter `Subnet Mask` -> `255.255.255.`
- Ensure `Override Default Gateway` checkbox is unchecked
- Click **NEXT**
- Click **FINISH**

#### Configure Host Time
- Select `Configure` -> `Time Configuration`
- For each esx host, select `Network Time Protocol` -> `EDIT` and configure as follows:

| device	| actual speed	| configured speed	| switch	| MAC address		|
| ---		| ---:		| ---:			| :---		| :---			|
| `vmnic0`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:01	|
| `vmnic1`	| 10 Gbits/s	| 10 Gbits/s		| fabric	| 00:de:ad:be:11:02	|

Under `Edit Network Time Protocol`
- Ensure `Enable` checkbox is checked
- Enter `NTP Servers` -> `10.30.0.30`
- Enter `NTP Service Status` -> `Start NTP Service`
- Enter `NTP Service Startup Policy` -> `Start and stop with host`
- Click **OK**
