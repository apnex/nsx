#!/bin/bash

# Goal
# POST - list minimum, and maximum (writable) spec according to openapi definition file of a given object
# DELETE - list minimum, and maximum (writable) spec according to openapi definition file of a given object
# GET - list minimum, and maximum (writable) spec according to openapi definition file of a given object

#ITEM="logical-switches"
ITEM="logical-routers"

# test workflow - logical-switch
read -r -d '' JQSPEC <<-CONFIG
	.paths."/${ITEM}".post.parameters
CONFIG
LSPOST=$(cat nsx-api.json | jq "$JQSPEC")
SCHEMA=$(echo "${LSPOST}" | jq -r '.[0].schema."$ref"')

function scanDef {
	REGEX='^#\/([^\/]+)\/([^\/]+)$'
	if [[ $SCHEMA =~ $REGEX ]]; then
		ANCHOR=${BASH_REMATCH[1]}
		INSTANCE=${BASH_REMATCH[2]}
		read -r -d '' JQSPEC <<-CONFIG
			."${ANCHOR}"."${INSTANCE}"
		CONFIG
		OUTPUT=$(cat nsx-api.json | jq "$JQSPEC")
		echo "$OUTPUT" | jq --tab .
	fi
}

scanDef "$SCHEMA"

echo "$OUTPUT" | jq --tab .
read -r -d '' JQSPEC <<-CONFIG
	(if (.origin_properties | length) != 0 then
		(.origin_properties[] | select(.key=="version").value)
	else
		"not-registered"
	end)
	."${ANCHOR}"."${INSTANCE}"
CONFIG
#OUTPUT=$(cat nsx-api.json | jq "$JQSPEC")

# if definition contains "allOf" - iterate through the array and collapse all properties together
#cat nsx-api.json | jq --tab '.definitions.LogicalSwitch.allOf[1]'
#LSREQ=$(cat nsx-api.json | jq --tab '.definitions.LogicalSwitch.allOf[1].required') ## foreach required property

#cat nsx-api.json | jq --tab '.definitions.LogicalSwitch.allOf[1].properties.admin_state' ## some properties have default values
#{
#	"enum": [
#		"UP",
#		"DOWN"
#	],
#	"type": "string",
#	"description": "Represents Desired state of the Logical Switch",
#	"title": "Represents Desired state of the Logical Switch"
#}
#cat nsx-api.json | jq --tab '.definitions.LogicalSwitch.allOf[1].properties.transport_zone_id'
#{
#	"type": "string",
#	"description": "Id of the TransportZone to which this LogicalSwitch is associated",
#	"title": "Id of the TransportZone to which this LogicalSwitch is associated"
#}
