#!/bin/bash

KEY="transport-node.id"

function getValue {
	cat data.json | jq ".${KEY}"
}

getValue
