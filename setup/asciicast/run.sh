#!/bin/bash

CAST=${1}
# set duration: 1
sed -i 's/["]duration["]: [[:digit:].]*/"duration": 1/g' ${CAST}
# set all interval 0.1
sed -i 's/^\([ ]*\)[[:digit:].e-]\+/\10.1/g' ${CAST}
# format through jq
cat ${CAST} | jq --tab . > temp.cast
mv temp.cast ${CAST}

# compile SVG output
svg-term --in ${CAST} --height 10 --width 129 --out temp.svg --window
cat temp.svg | xmllint --format - > ${CAST}.svg
sed -i 's/f{fill:#b9c0cb}/f{fill:#00ff00}/g' ${CAST}.svg
#sed -i "s/animation-iteration-count:infinite;/animation-iteration-count:1;animation-fill-mode:forwards;/g" sddc.status.svg

# add in colour modifications
