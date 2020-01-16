#!/bin/bash

set -o vi
VALUE="s/^set completion-display-width //p"
printf "%s" "${VALUE}" 1>&2
SKIPC=$(bind -v | sed -n "${VALUE}")
printf "%s" "${SKIPC}" 1>&2

