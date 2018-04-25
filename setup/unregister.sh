#!/bin/bash
# this script does not yet work!

USER=$(cat vcsa-credentials | jq -r .username)
PASS=$(cat vcsa-credentials | jq -r .password)
HOST=$(cat vcsa-credentials | jq -r .hostname)
DOMAIN=$(cat vcsa-credentials | jq -r .domain)

#--data-urlencode "password=$PASS" \
#--data-urlencode "username=$USER" \
function login {
	#URL="https://$HOST/rest/com/vmware/cis/session"

	URL="https://vcenter.lab/mob/?moid=ExtensionManager"
	curl -k -c vccookies.txt -b vccookies.txt -D vcheaders.txt -G -X GET \
	-u $USER:$PASS \
	"$URL"
	sleep 2

	URL="https://vcenter.lab/mob/?moid=ExtensionManager&method=unregisterExtension"
	curl --verbose -k -c vccookies.txt -b vccookies.txt -G -X POST \
	-A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36" \
	-H "Origin: https://vcenter.lab" \
	-H "Referer: https://vcenter.lab/mob/?moid=ExtensionManager&method=unregisterExtension" \
	--data-urlencode "extensionKey=com.vmware.nsx.management.nsxt" \
	--data-urlencode "vmware-session-nonce=5284c1ad-2009-f571-7a76-0e37cc3ced41" \
	"$URL"
}

login

#-H "`grep X-XSRF-TOKEN headers.txt`" \
#"https://vcenter.lab/mob/?moid=ExtensionManager&method=unregisterExtension
#-H "vmware-session-nonce: 527462e3-abe4-2671-3e9e-a989a32bd898"
#-d "extensionKey=com.vmware.nsx.management.nsxt"

#curl -X POST \
#  'https://vcenter.lab/mob/?moid=ExtensionManager&method=unregisterExtension' \
#  -H 'content-type: application/x-www-form-urlencoded' \
#  -H 'cookie: vmware_debug_session=\"a9634a9f02d8d3672a381150e25d978ed56659d3\"' \
#  -H 'origin: https://vcenter.lab' \
#  -H 'postman-token: f3b48a40-8616-17ed-36bd-52dd3818406e' \
#  -b 'vmware_debug_session=\"a9634a9f02d8d3672a381150e25d978ed56659d3\"'
