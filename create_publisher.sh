#!/usr/bin/env bash

PUBLISHER_ADDR=$1
if [ -z "$PUBLISHER_ADDR"  ]
then
    PUBLISHER_ADDR=oZZ7YtpY1RGHV65bdVJSu4ak7eneLjcYFv
fi

OIP_HOST=http://35.230.92.250:41289
TIMESTAMP=`date +%s`
CODE=$RANDOM
PUB_NAME="Apple Registrar $CODE"

function jsonval {
    temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROP`
    echo ${temp##*|}
}

SIG_MESSAGE="{\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$PUB_NAME-$PUBLISHER_ADDR-$TIMESTAMP\"}"
echo "Signature message: $SIG_MESSAGE"
JSON=`curl -X POST -H "Content-Type: application/json" --data "$SIG_MESSAGE" $OIP_HOST/alexandria/v1/sign`
PROP='response'
PUB_SIG=`jsonval | cut -d ':' -f2 | cut -d '[' -f2 | cut -d ']' -f1`

REGISTER_PUBLISHER="{\"alexandria-publisher\":{\"name\":\"$PUB_NAME\",\"address\":\"$PUBLISHER_ADDR\",\"timestamp\":$TIMESTAMP,\"bitmessage\":\"\",\"emailmd5\":\"\"},\"signature\":\"$PUB_SIG\"}"
echo "Registering publisher with signature."
curl -X POST -H "Content-Type: application/json" --data "$REGISTER_PUBLISHER" $OIP_HOST/alexandria/v1/send
