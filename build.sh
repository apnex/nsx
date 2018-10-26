#!/bin/bash
docker rmi -f apnex/nsx-cli 2>/dev/null
docker build --no-cache -t apnex/nsx-cli -f nsx-cli.docker .
