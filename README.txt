# list existing certs in NSX manager
./cert.list.sh

# build new rootCA cert, create and sign new NSXM cert, and build cert-import.json for upload
./rebuild-all-certs.sh

# upload new NSXM certificate
./cert.import.sh

# check that newly uploaded certificate exists - copy ID of certificate for next command
./cert.list.sh

# apply newly uploaded certificate to the NSXM API service - NSX web service will restart
./cert.apply.sh <cert-id>

# check that certificate is now applied
./cert.list.sh json
