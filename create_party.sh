#!/usr/bin/env bash

PUBLISHER_ADDR=$1
if [ -z "$PUBLISHER_ADDR" ]
then
    PUBLISHER_ADDR=oZZ7YtpY1RGHV65bdVJSu4ak7eneLjcYFv
fi

OIP_HOST=http://35.230.92.250:41289
TIMESTAMP=`date +%s`
IPFS_DIR="/ds-property/tmp-$RANDOM"
ipfs files mkdir -p $IPFS_DIR
FNAME="document.txt"
echo "Party Entity $IPFS_DIR placeholder text" | ipfs files write --create $IPFS_DIR/$FNAME
IPFS_LOCATION=`ipfs files stat --hash $IPFS_DIR`
FSIZE=`ipfs files stat --size $IPFS_DIR/$FNAME`
DISPLAY_NAME="Placeholder"
FTYPE="Placeholder"
CONTENT_TYPE="text/plain"
PARTY_TITLE="Property Party $IPFS_DIR"

function jsonval {
    temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROP`
    echo ${temp##*|}
}

echo "Signing with this message: {\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}"
JSON=`curl -X POST -H "Content-Type: application/json" --data "{\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}" $OIP_HOST/alexandria/v1/sign`
PROP='response'
PUB_SIG=`jsonval | cut -d ':' -f2 | cut -d '[' -f2 | cut -d ']' -f1`

read -r -d '' PARTY_TEMPLATE << EOF
{"oip042":{"publish":{"artifact":{"floAddress":"${PUBLISHER_ADDR}","timestamp":${TIMESTAMP},"type":"property","subtype":"party","details":{"ns":"DS","partyRole":"citizen","partyType":"naturalPerson","attrs":[]},"info":{"title":"${PARTY_TITLE}","description":"UsefulDescription","tags":"party,test,demo,oip042"},"storage":{"network":"ipfs","location":"${IPFS_LOCATION}","files":[{"fName":"${FNAME}","fSize":${FSIZE},"dName":"${DISPLAY_NAME}","type":"${FTYPE}","cType":"${CONTENT_TYPE}"}]},"signature":"${PUB_SIG}"}}}}
EOF

echo "${PARTY_TEMPLATE}"

curl -X POST -H "Content-Type: application/json" --data "${PARTY_TEMPLATE}"  ${OIP_HOST}/alexandria/v1/send
