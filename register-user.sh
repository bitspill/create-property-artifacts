#!/usr/bin/env bash

FLO_CONF=`pwd`/flo.conf
NEW_ADDRESS=`flo-cli -conf=$FLO_CONF getnewaddress`
echo "New address: $NEW_ADDRESS"

TIMESTAMP=`date +%s`
EMAIL=$1
DEVICE_ID=$RANDOM

REGISTER_DATA="{\"email\":\"$EMAIL\",\"device_id\":\"$DEVICE_ID\",\"auth_address_base58\":\"$NEW_ADDRESS\",\"timestamp\":\"$TIMESTAMP\"}"

curl -H "Content-Type: application/json" -d "$REGISTER_DATA" http://localhost:9993/mobile-register-user
