#### 1: Set up NSX manager credentials
Modify the `nsx-credentials` file to reflect the parameters for your lab. I recommended using an IP address for the `hostname`.
The `domain` property will be used in generating a certificate for the NSX Manager - i.e `*.lab` in this example.

```json
{
	"hostname": "172.16.10.15",
	"username": "admin",
	"password": "VMware1!VMware1!",
	"domain": "lab",
	"offline": "false"
}
```

#### 2: List existing certs in NSX manager
```
./cert.list.sh
```

#### 3: Build new rootCA cert, create and sign new NSXM cert, and build cert-import.json for upload
```
./rebuild-all-certs.sh
```

#### 4: Upload newly created certificate to NSX Manager
```
./cert.import.sh
```

#### 5: Check that newly uploaded certificate exists - get `<cert-id>` of certificate for next command
```
./cert.list.sh
```

#### 6: Apply newly uploaded certificate to the HTTP API service - NSX web service will restart
```
./cert.apply.sh <cert-uuid>
```

#### 7: Check that certificate is now applied to API HTTP service
```
./cert.list.sh json
```
