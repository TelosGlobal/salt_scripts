#!/bin/bash

n=0

echo "Waiting for TelosGlobal to finish their turn..."
# continue until BPNOW = telosglobal1 and $n equals 1
while [[ $BPNOW != 'telosglobal1' ]] || [[ $n -ne 1 ]]
do
    BPGET=`curl -sS 'https://node1.na.telosglobal.io:8899/v1/chain/get_info' | jq -c '.head_block_producer'`
    #echo $BPGET
    BPNOW=${BPGET:1:12}
    echo "Currently on: $BPNOW"
    echo $n
    
    if [ $BPNOW == "telosglobal1" ]
    then
        n=1
    fi
    sleep 5s
done
echo "Time to switch config files..."

#Change config.ini on usmainnnetprdr01
salt 'usmainnet*rdr01' cmd.run 'cp /ext/telos-build/telos/prod.config.ini config.ini'
echo "changed"

#Change config.ini on nymainnnetprdr01
salt 'usmainnetprdr01' cmd.run 'cp /ext/telos-build/telos/prod.config.ini config.ini'
echo "changed"

