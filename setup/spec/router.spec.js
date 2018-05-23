#!/usr/bin/env node

var $nsxapi = require('./nsx-api.json');

// print first level keys
for(let key of Object.keys($nsxapi)) {
	//console.log('key [' + key+ ']');
}

// base definition
var $item = "logical-routers";
var $path = $nsxapi.paths['/' + $item].post.parameters;
//console.log(JSON.stringify($path, null, "\t"));
var $schema = $path[0].schema["$ref"];
console.log("Definition [" + $schema + "]");

// #/definitions/LogicalRouter
let $regex = /#\/definitions\/([a-z0-9A-Z]+)$/g;
let $match = $regex.exec($schema);
console.log(JSON.stringify($match, null, "\t"));
let $defKey = $match[1];

console.log("Definition [" + $defKey + "]");
let $fullspec = $nsxapi.definitions[$defKey].allOf[1].properties;
let $minspec = $nsxapi.definitions[$defKey].allOf[1].required;

// create minimum writable spec
let $result = [];
if($minspec) { // if has required fields
	for(let $key of Object.values($minspec)) {

		// check if contain enum, and expand
		$result.push($fullspec[$key]);
		console.log('key [' + $key + ']');
	}
}

// create maximum writable spec
let $newspec = {};
for(let $key of Object.keys($fullspec)) {
	if($fullspec[$key].readOnly != true) {
		//if($fullspec[$key].type == "string" || $fullspec[$key].type == "integer") {
			$result.push($fullspec[$key]);
			$newspec[$key] = $fullspec[$key].type;
			console.log('key [' + $key + ']');
		//} else {
		//	console.log('nope!! [' + $key + ']');
		//}
	}
}

// output result
console.log(JSON.stringify($result, null, "\t"));
//console.log(JSON.stringify($newspec, null, "\t"));
