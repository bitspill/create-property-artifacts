#!/usr/bin/env bash
PUBLISHER_ADDR=$1
if [ -z "$PUBLISHER_ADDR" ]
then
    PUBLISHER_ADDR=oZZ7YtpY1RGHV65bdVJSu4ak7eneLjcYFv
fi

PARTY_ID=$2
if [ -z "$PARTY_ID" ]
then
    PARTY_ID=dd0fad83b3f346dcd244dfb730dafade8940dd8ad2342acd31789e552da4743e
fi

SPAT_ID=$3
if [ -z "$SPAT_ID" ]
then
    SPAT_ID=0037bbf3895c9a0bd18ea92ab991a298f3703830261722df0e86d37cafe73520
fi

OIP_HOST=http://35.230.92.250:41289

TIMESTAMP=`date +%s`
IPFS_DIR="/ds-property/tmp-tenure-$RANDOM"
ipfs files mkdir -p $IPFS_DIR
FNAME="document_$RANDOM.txt"
echo "Tenure Entity $IPFS_DIR placeholder documentation." | ipfs files write --create $IPFS_DIR/$FNAME
IPFS_LOCATION=`ipfs files stat --hash $IPFS_DIR`
FSIZE=`ipfs files stat --size $IPFS_DIR/$FNAME`
DISPLAY_NAME="Tenure Entity $IPFS_DIR"
FTYPE="Placeholder"
CONTENT_TYPE="text/plain"
TENURE_TITLE="Property Tenure $IPFS_DIR"

function jsonval {
    temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROP`
    echo ${temp##*|}
}

SIGN_MESSAGE="{\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}"
echo "Signing with this message: $SIGN_MESSAGE"
JSON=`curl -X POST -H "Content-Type: application/json" --data "$SIGN_MESSAGE" $OIP_HOST/alexandria/v1/sign`
PROP='response'
PUB_SIG=`jsonval | cut -d ':' -f2 | cut -d '[' -f2 | cut -d ']' -f1`

read -r -d '' SPAT_TEMPLATE << EOF
{"oip042":{"publish":{"artifact":{"floAddress":"${PUBLISHER_ADDR}","timestamp":${TIMESTAMP},"type":"property","subtype":"tenure","details":{"ns":"DS","tenureType":"freehold","party":"${PARTY_ID}","spatialUnit":"${SPAT_ID}","attrs":[]},"info":{"title":"${TENURE_TITLE}","description":"${TENURE_TITLE} Description","tags":"tenure,test,demo,oip042"},"storage":{"network":"ipfs","location":"${IPFS_LOCATION}","files":[{"fName":"${FNAME}","fSize":12345,"dName":"${DISPLAY_NAME}","type":"${FTYPE}","cType":"${CONTENT_TYPE}"}]},"signature":"${PUB_SIG}"}}}}
EOF

echo "$SPAT_TEMPLATE"

curl -X POST -H "Content-Type: application/json" --data "${SPAT_TEMPLATE}"  $OIP_HOST/alexandria/v1/send
