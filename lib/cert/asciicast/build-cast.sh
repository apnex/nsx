#!/bin/bash
svg-term --in sddc.status.cast --height 10 --width 129 --out temp.svg --window
cat temp.svg | xmllint --format - > sddc.status.svg
sed -i 's/f{fill:#b9c0cb}/f{fill:#00ff00}/g' sddc.status.svg
#sed -i "s/animation-iteration-count:infinite;/animation-iteration-count:1;animation-fill-mode:forwards;/g" sddc.status.svg

# add in colour modifications
