#### 1: Set up sddc endpoints and parameters
Modify the `sddc.parameters` file to reflect the parameters for your lab accordingly.

The `dns` field will be used to verify forward and reverse dns entries for each endpoint.

The `domain` property will be used in generating a certificate for the NSX Manager - i.e `*.lab` in this example.

For NSX certificate operations, the **vsp** is optional and not required.
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
![sddc.status](sddc.svg)
To view extended parameters (credentials / certificate) issue the following:
```
./sddc.status.sh json
```

#### 3: List existing certs in NSX manager
```
./cert.list.sh
```

#### 4: Build new rootCA cert, create and sign new NSXM cert, and build cert-import.json for upload
This command will generate and sign new certificates, and store them in the **state/** folder
```
./rebuild-all-certs.sh
```

#### 5: Upload newly created certificate to NSX Manager
```
./cert.import.sh
```

#### 6: Check that newly uploaded certificate exists - get `<cert-id>` of certificate for next command
```
./cert.list.sh
```

#### 7: Apply newly uploaded certificate to the HTTP API service - NSX web service will restart
```
./cert.apply.sh <cert-uuid>
```

#### 8: Check that certificate is now applied to API HTTP service
```
./cert.list.sh json
```
