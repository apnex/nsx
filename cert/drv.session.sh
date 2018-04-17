#!/bin/bash

USER=$(cat nsx-credentials | jq -r .username)
PASS=$(cat nsx-credentials | jq -r .password)
HOST=$(cat nsx-credentials | jq -r .hostname)

function login {
	URL="https://$HOST/api/session/create"
	curl -k -c cookies.txt -D headers.txt -X POST \
	-d "j_username=$USER&j_password=$PASS" \
	"$URL" 2>/dev/null
}

SESSIONFILE='cookies.txt'
printf "Validating existing session...\n" 1>&2
if [ -f $SESSIONFILE ]; then
	MYDATE=$(stat -c %y cookies.txt)
	LAPSE="$(($(date '+%s') - $(date -d "$MYDATE" '+%s')))"
	printf "File [$SESSIONFILE] exists - age [$LAPSE]\n" 1>&2
	if [ "$LAPSE" -ge 600 ]; then
		printf "Session older than [600] seconds, reauthenticating...\n" 1>&2
		login
	fi
else
	printf "File [$SESSIONFILE] does not exist - authenticating...\n" 1>&2
	login
fi

