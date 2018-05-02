#!/usr/bin/env node

var readline = require('readline');
var rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
	terminal: false
});

var $text = "";
rl.on('line', function($line) {
	$text += ' ' + $line;
})

rl.on('close', function() {
	$text = $text.replace(/\s+/g, " ");
	//let regex = /(description": ")(.+?)((" } }, ")|(" } ], ")|(" }, ")|(", "))/g
	//let regex = /((?:description|title)": ")(.+?)("[ }\],]{2,}")/g
	let regex = /((?:description|title)": ")(.+?)("[ }\],]{2,}")/g
	$text = $text.replace(
		regex, function(match, $1, $2, $3) {
			let $key = $2;
			$key = $key.replace(/"/g, "'");
			$key = $key.replace(/\//g, function(c) {
				return '\/';
			}).replace(/\\/g, function(c) {
				return '\\\\';
			}).replace(/[\u003c\u003e]/g, function(c) {
				return '\\u'+('0000'+c.charCodeAt(0).toString(16)).slice(-4).toUpperCase();
			}).replace(/[\u007f-\uffff]/g, function(c) {
				return '\\u'+('0000'+c.charCodeAt(0).toString(16)).slice(-4);
			});
			return $1 + $key + $3;
		}
	);
	regex = /(pattern": ")(.+?)("[ }\],]{2,}")/g
	$text = $text.replace(
		regex, function(match, $1, $2, $3) {
			let $key = $2;
			$key = $key.replace(/\\/g, function(c) {
				return '\\\\';
			}).replace(/[\u003c\u003e]/g, function(c) {
				return '\\u'+('0000'+c.charCodeAt(0).toString(16)).slice(-4).toUpperCase();
			}).replace(/[\u007f-\uffff]/g, function(c) {
				return '\\u'+('0000'+c.charCodeAt(0).toString(16)).slice(-4);
			});
			return $1 + $key + $3;
		}
	);
	console.log($text)
});
