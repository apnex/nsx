#### 1: Ensure you have JQ and CURL installed
Ensure you meet the pre-requisites on linux to execute to scripts.
Currently, these have been tested on Centos.

##### Centos
```shell
yum install curl jq
```

##### Ubuntu
```shell
apt-get install curl jq
```

##### Mac OSX
Install brew
```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
```

Install curl & jq
```shell
brew install curl jq
```

#### 2: Clone repository from GitHub
Perform the following command to download the scripts - this will create a directory `nsx` on your local machine
```shell
git clone https://github.com/apnex/nsx
```

#### 3: Set up sddc endpoints and parameters
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

#### 4: Verify sddc status
This will perform a forward and reverse dns tests for each endpoint against the server @ `dns`.  
It will also perform a **ping** to the `hostname`.`domain` - if hostname is alphanumeric, or simply `hostname` if an IP address is specified.  
The SSL thumprint and certificate is also tested/extracted to indicate correct connectivity.  
![sddc.status](asciicast/sddc.status.svg)
To view extended parameters (credentials / certificate) issue the following:
```
./sddc.status.sh json
```

#### 5: List existing certs in NSX manager
```
./cert.list.sh
```

#### 6: Build new rootCA cert, create and sign new NSXM cert, and build cert-import.json for upload
This command will generate and sign new certificates, and store them in the **state/** folder
```
./rebuild-all-certs.sh
```

#### 7: Upload newly created certificate to NSX Manager
```
./cert.import.sh
```

#### 8: Check that newly uploaded certificate exists - get `<cert-id>` of certificate for next command
```
./cert.list.sh
```

#### 9: Apply newly uploaded certificate to the HTTP API service - NSX web service will restart
```
./cert.apply.sh <cert-uuid>
```

#### 10: Check that certificate is now applied to API HTTP service
```
./cert.list.sh json
```
