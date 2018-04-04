#!/usr/bin/env bash

PUBLISHER_ADDR=oHhgRuDVMvKJMZuuvT2ChgxQormVaHKwSo
TIMESTAMP=`date +%s`
IPFS_DIR="/ds-property/tmp-$RANDOM"
ipfs files mkdir -p $IPFS_DIR
FNAME="placeholder.txt"
echo "Party Entity placeholder text" | ipfs files write --create $IPFS_DIR/$FNAME
IPFS_LOCATION=`ipfs files stat --hash $IPFS_DIR`
FSIZE=`ipfs files stat --size $IPFS_DIR/$FNAME`
DISPLAY_NAME="Placeholder"
FTYPE="Placeholder"
CONTENT_TYPE="text/plain"

function jsonval {
    temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROP`
    echo ${temp##*|}
}

JSON=`curl -X POST -H "Content-Type: application/json" --data "{\"address\":\"$PUBLISHER_ADDR\",\"text\":\"$IPFS_LOCATION-$PUBLISHER_ADDR-$TIMESTAMP\"}" http://35.230.92.250:41289/alexandria/v1/sign`
PROP='response'
PUB_SIG=`jsonval | cut -d ':' -f2 | cut -d '[' -f2 | cut -d ']' -f1`

read -r -d '' PARTY_TEMPLATE << EOF
{"oip-041":
    {"artifact":
      {
        "timestamp": $TIMESTAMP,
        "type": "property",
        "subtype": "party",
        "publisher":"$PUBLISHER_ADDR",
        "info":
          {
            "title":"Property Title",
            "description":"Useful description",
            "year": 2018,
            "tags": "party,test,demo",
            "ns": "DS",
            "partyRole": "citizen",
            "partyType": "naturalPerson",
            "attrs": [ ],
            "extraInfo": { }
          },
         "storage":
           {
             "network":"IPFS",
             "location":"$IPFS_LOCATION",
             "files": [
               {
                 "fName":"$FNAME",
                 "fSize":$FSIZE,
                 "dName":"$DISPLAY_NAME",
                 "fType": "$FTYPE",
                 "cType": "$CONTENT_TYPE"
               }
             ]
           }
      },
     "signature": "$PUB_SIG"
     }
}
EOF

echo "$PARTY_TEMPLATE"

curl -X POST -H "Content-Type: application/json" --data "${PARTY_TEMPLATE}"  http://35.230.92.250:41289/alexandria/v1/send
