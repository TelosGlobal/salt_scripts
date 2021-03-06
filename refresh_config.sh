#!/bin/bash

echo "Which region config should we install:"
echo "1. us"
echo "2. apac"
echo "3. emea"
read -p "Choose (1,2,3) : " region
if [ $region = 1 ] 
then 
    region="us"
elif [ $region = 2 ]
then
    region="apac"
elif [ $region = 3 ]
then
    region="emea"
else
    echo "error"
    region="error"
fi
echo "Region: $region" 
if [ $region = "us" ]
then
    echo "Which network config should we install:"
    echo "1. mainnet"
    echo "2. stagenet"
    echo "3. testnet"
    echo "4. testnet2"
    read -p "Choose (1,2,3,4) : " network
    if [ $network = 1 ]
    then 
	network="mainnet"
    elif [ $network = 2 ]
    then
	network="stagenet"
    elif [ $network = 3 ]
    then
	network="testnet"
    elif [ $network = 4 ]
    then
	network="testnet2"
    else
        echo "error"
        network="error"
    fi
    area=""
    if [ $network = "mainnet" ]
    then
      echo ""
      echo "Which area config should we install:"
      echo "1. ny"
      echo "2. sj"
      echo "3. va"
      read -p "Choose (1,2,3) : " area
      if [ $area = 1 ]
      then
	area="ny"
      elif [ $area = 2 ]
      then
	area="sj"
      elif [ $area = 3 ]
      then
	area="va"
      else
        echo "error"
        area="error"
      fi
    fi
else
    network="mainnet"
fi
echo "Network: $network"
echo "Area: $area"
echo ""
echo "Which server config should we install:"
echo "1. node01"
echo "2. node02"
echo "3. prdr01"
echo "4. prdr02 (Only in MAINNET VA & NY)"	
read -p "Choose (1,2,3,4) : " node
if [ $node = 1 ]
then 
    node="node01"
elif [ $node = 2 ]
then
    node="node02"
elif [ $node = 3 ]
then
    node="prdr01"
elif [ $node = 4 ]
then
    node="prdr02"
else
    echo "error"
    node="error"
fi
target=$region$network$area$node
echo "Target node: $target"
echo "Pinging salt minion..."
sudo salt $target test.ping
read -p "Copy config.ini? (y/n): " confirm1
if [ $confirm1 == "Y" ] || [ $confirm1 == "y" ]
then
   if [ $region = "us" ] && [ $network = "mainnet" ]
   then
       echo "Copying the config.ini for $target..." 
       sudo salt $target cp.get_file salt://config/$region/$network/$area.$node.config.ini /ext/telos/config/config.ini makedirs=True
   else
       echo "Copying the config.ini for $target..." 
       sudo salt $target cp.get_file salt://config/$region/$network/$node.config.ini /ext/telos/config/config.ini makedirs=True
   fi
fi
read -p "Copy genesis.json? (y/n): " confirm2
if [ $confirm2 == "Y" ] || [ $confirm2 == "y" ]
then
    echo "Copying the genesis.json for $target..." 
    sudo salt $target cp.get_file salt://config/genesis/$network/genesis.json /ext/telos/config/genesis.json makedirs=True
fi
if [ $confirm1 == "Y" ] || [ $confirm1 == "y" ] || [ $confirm2 == "Y" ] || [ $confirm2 == "y" ]
then
    echo "Updating file permissions for /ext..."
    sudo salt $target cmd.run 'chown -R telosuser /ext/*'
    echo "Permissions updated."
fi
echo "Refresh complete."

