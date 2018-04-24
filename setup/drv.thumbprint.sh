#!/bin/bash

OPT=$2
PAYLOAD=$(echo -n | openssl s_client -connect "$1" 2>/dev/null)

if [[ "$OPT" == "thumbprint" ]]; then
	PRINT=$(echo "$PAYLOAD" | openssl x509 -noout -fingerprint -sha256)
	#REGEX='^(.*)=(.*)$'
	REGEX='^(.*)=(([0-9A-Fa-f]{2}[:])+([0-9A-Fa-f]{2}))$'
	if [[ $PRINT =~ $REGEX ]]; then
		TYPE=${BASH_REMATCH[1]}
		CODE=${BASH_REMATCH[2]}
	fi
	echo $CODE | sed "s/\(.*\)/\L\1/g" | sed "s/://g"
else
	echo "$PAYLOAD" |  sed -e '1h;2,$H;$!d;g' -e 's/.*\(-----BEGIN\sCERTIFICATE-----.*-----END\sCERTIFICATE-----\).*/\1/g'
fi

