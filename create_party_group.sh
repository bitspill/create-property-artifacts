#!/usr/bin/env bash

# Known PUBLISHER_ADDR=oZZ7YtpY1RGHV65bdVJSu4ak7eneLjcYFv
#
USAGE="Usage: $0 publisher_addr member1 member2 ... memberN"

if [ "$# " == "0" ]; then
	echo "$USAGE"
	exit 1
fi

if [ $# -ge 1 ]
then
    PUBLISHER_ADDR=$1
    shift
fi

MEMBERS_JSON="["
MEMBER_COUNT=0
while (( "$#" ))
do
  MEMBERS[$((MEMBER_COUNT++))]=$1
  shift
done

OIP_HOST=http://35.230.92.250:41289
TIMESTAMP=`date +%s`
IPFS_DIR="/ds-property/tmp-$RANDOM"
ipfs files mkdir -p $IPFS_DIR
FNAME="document_$IPFS_DIR.txt"
echo "Party Entity $IPFS_DIR placeholder text" | ipfs files write --create $IPFS_DIR/$FNAME
IPFS_LOCATION=`ipfs files stat --hash $IPFS_DIR`
FSIZE=`ipfs files stat --size $IPFS_DIR/$FNAME`
DISPLAY_NAME="Placeholder"
FTYPE="Placeholder"
CONTENT_TYPE="text/plain"
PARTY_TITLE="Property Party $IPFS_DIR"
PARTY_TYPE="group"

function jsonval {
    temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROP`
    echo ${temp##*|}
}

echo "Signing with this message: {\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}"
JSON=`curl -X POST -H "Content-Type: application/json" --data "{\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}" $OIP_HOST/alexandria/v1/sign`
PROP='response'
PUB_SIG=`jsonval | cut -d ':' -f2 | cut -d '[' -f2 | cut -d ']' -f1`

MEM_ITER=0
for MEMBER in ${MEMBERS[@]}
do
  MEMBERS_JSON+="\"$MEMBER\""
  if ((++MEM_ITER < $MEMBER_COUNT))
  then
    MEMBERS_JSON+=","
  fi
done
MEMBERS_JSON+="]"

read -r -d '' PARTY_TEMPLATE << EOF
{"oip-041":{"artifact":{"timestamp":$TIMESTAMP,"type":"property","subtype":"party","publisher":"$PUBLISHER_ADDR","info":{"title":"$PARTY_TITLE","description":"Usefuldescription","year":2018,"tags":"party,test,demo","ns":"DS","partyRole":"association","partyType":"$PARTY_TYPE","members":$MEMBERS_JSON,"attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"$IPFS_LOCATION","files":[{"fName":"$FNAME","fSize":$FSIZE,"dName":"$DISPLAY_NAME","fType":"$FTYPE","cType":"$CONTENT_TYPE"}]}},"signature":"$PUB_SIG"}}
EOF

echo "$PARTY_TEMPLATE"

curl -X POST -H "Content-Type: application/json" --data "${PARTY_TEMPLATE}"  $OIP_HOST/alexandria/v1/send
