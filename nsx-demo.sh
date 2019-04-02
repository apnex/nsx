#!/bin/bash

# logical-switches.create <name> <tz-uuid> [ <vlan> ]

SWITCH_PREFIX="demo"
TZ_UUID="b7c3c2d8-b0b0-4cdd-a469-a5faa7f22cb0"

header() {

  clear
  echo
  echo "$1"
  echo

}

enterPrompt() {

  echo
  echo -n "$1"
  read CONTINUE

}

header "***** Node Status *****"
/home/smitah5/nsx/lib/cmd.nodes.status.sh
enterPrompt "Press ENTER to list logical switches "

header "***** Logical Switches *****"
/home/smitah5/nsx/lib/cmd.logical-switches.list.sh
enterPrompt "Press ENTER to create 10x demo logical switches "

for SWITCH_NUM in `seq 1 10`; do
  /home/smitah5/nsx/lib/cmd.logical-switches.create.sh $SWITCH_PREFIX-$SWITCH_NUM $TZ_UUID
done

header "***** Logical Switches *****"
/home/smitah5/nsx/lib/cmd.logical-switches.list.sh
enterPrompt "Press ENTER to delete all demo switches "

for UUID in `/home/smitah5/nsx/lib/cmd.logical-switches.list.sh | grep demo | cut -d' ' -f1`; do
  /home/smitah5/nsx/lib/cmd.logical-switches.delete.sh $UUID
done

header "***** Logical Switches *****"
/home/smitah5/nsx/lib/cmd.logical-switches.list.sh
echo