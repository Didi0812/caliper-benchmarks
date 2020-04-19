#!/bin/bash

#
# This is used at Container start up to run the Tessera and geth nodes
#

set -u
set -e

### Configuration Options
TMCONF=/qdata/config.json

#GETH_ARGS="--datadir /qdata/dd --istanbul.blockperiod 1 --syncmode full --mine --minerthreads 1  --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --nodiscover --unlock 0 --password /qdata/passwords.txt"
GETH_ARGS="--datadir /qdata/dd --rpcport 8545 --port 30303 --raftport 50400 --identity master-3 --istanbul.blockperiod 1 --syncmode full --mine --minerthreads 1  --rpc --rpccorsdomain=* --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,clique,raft,istanbul --ws --wsaddr 0.0.0.0 --wsorigins=* --wsapi eth,web3,quorum,txpool,net --wsport 8546 --unlock 0 --password /qdata/passwords.txt --networkid 10 --bootnodes enode://cded1a5d2dd2169d990ef325044c410608ef33137d30a4526006d55a2aa90eb71eb78b50e935b969ddb494f892bd5e1eaa470fc53a441269e57b8c95e87bb3d5@172.13.0.2:30303,enode://d8356a7375799cfab1f5a676be6e01c33c8ddfbef70ffc15b37c8d81a0bf49cb3367922167b102f2777369ff9616ddadd2d68f805024ecd8babf6ea7ad2e9a04@172.13.0.3:30303,enode://012537e34ef024c3cf59e7f7cc62df2474030c6a79421eb75a8a83ccc2dfcdb646d77be4c1618242d58512d3843b01c686a514f7b058a42dff07fd3c892f490a@172.13.0.4:30303,enode://7b5c094e651245e2f309de45c3b8122b7f3e8aa7b4599877a6e0237ec8f665697f93b8610f0261ebf8a79d4117724fec39a0e00f6eb4a2aa0973d9d76a78ea58@172.13.0.5:30303,enode://46f57c5862f7cf292b3e5503789104c528f00ac0b7856f40b22fb9b16f369dc59706613923ff1ab08c52abf24044d593e7fe05d06d8ea631f0a3dba612d62b88@172.13.0.6:30303"


if [ ! -d /qdata/dd/geth/chaindata ]; then
  echo "[*] Mining Genesis block"
  /usr/local/bin/geth --datadir /qdata/dd init /qdata/genesis.json
fi

# echo "[*] Starting Constellation node"
# nohup /usr/local/bin/constellation-node $TMCONF 2>> /qdata/logs/constellation.log &

echo "[*] Starting Tessera node"
java -jar /tessera/tessera-app.jar -configfile $TMCONF >> /qdata/logs/tessera.log 2>&1 &

sleep 60

echo "[*] Starting Geth node"
PRIVATE_CONFIG=/qdata/tm.ipc nohup /usr/local/bin/geth $GETH_ARGS 2>>/qdata/logs/geth.log