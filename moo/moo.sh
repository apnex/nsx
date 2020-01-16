#!/bin/bash

ARRAY=()
ARRAY+=("moo1")
ARRAY+=("moo2")
ARRAY+=("moo3")
ARRAY+=("moo4")

printf "<someparam>\n" 1>&2
printf "${PS1@P}"
for ARG in ${ARRAY[@]:0:${#ARRAY[@]}-1}; do
	printf "%s " "${ARG}" 1>&2
done
printf "${ARRAY[-1]}"
printf "\nEND\n"
