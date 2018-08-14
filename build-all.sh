#!/bin/bash

# join and prep esx node
#./node.join.sh 172.16.10.101

# setup tzones, profiles, pools
./tzone.create.sh tz-tunnel hs-fabric OVERLAY
sleep 1
./tzone.create.sh tz-vlan hs-fabric VLAN
sleep 1
./hostswitch-profile.create.sh pf-uplink 1700 12
sleep 1
./pool.create.sh tep-pool 172.16.11.0/24

# build transport node
#./node.status.sh
#./tnode.create.sh tn-esx01 97890eb6-5091-4692-a72d-e05337dfc350

# build edge
#./edge.create.sh nsxe01.lab 172.16.10.18
#./tnode.create.sh tn-edge01 e02a8cfe-cab4-447b-8694-5312598bbf0d
#/edge-cluster.create.sh edge-cluster e02a8cfe-cab4-447b-8694-5312598bbf0d

# switch external
#./switch.create.sh ls-external 8ebfe9fb-307c-422e-ba09-4636bf416810 5
