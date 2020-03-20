#!/bin/bash

#
# This is used at Container start up to run the Tessera and geth nodes
#

set -u
set -e

### Configuration Options
TMCONF=/qdata/config.json

#GETH_ARGS="--datadir /qdata/dd --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --nodiscover --unlock 0 --password /qdata/passwords.txt"
GETH_ARGS="--datadir /qdata/dd --rpcport 8545 --port 30303 --raftport 50400 --identity -5 --raft --rpc --rpccorsdomain=* --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,clique,raft,istanbul --ws --wsaddr 0.0.0.0 --wsorigins=* --wsapi eth,web3,quorum,txpool,net --wsport 8546 --unlock 0 --password /qdata/passwords.txt --networkid 10 --bootnodes enode://25cc55b8c1a9232787d136b97a85653557193474c49e389256c08ce204d7a65a952d4fe535c20a6e87098481c0cd2fa602431c6642b0ee4dc3ea2a85db0d64b6@172.13.0.2:30303,enode://2de989ac5af8d9d367dac1f3471282412454782611ba027e108cf58b9f58d2a970d0720eed45bf0fd826940a408d70b3e37bfb8ee77dc2b4fedb52abd9040830@172.13.0.3:30303,enode://9a2a30a22cfa02458194f3e621531f6132b522e4b74072958b1653ec8f5bebe76204467d4e84c7f55941ce1dd985ffe547525a8930093dca847c87fdeb955f4e@172.13.0.4:30303,enode://4e0d1f9190c7a7a69051d49ffe6493feeca69eec7b5d9f2efdd7518056af9594329800f66a6f8fac9a9f6748220e440105173bc4975ad4ad6d88c589e8ab947a@172.13.0.5:30303,enode://053f55d43960f2720a1eddd2cbbada8a1f3f8cfa472eb11d4581b9f81566e010dc2e230bdd97dd53d8e66c63e8e17a85ccf89e1245f75923747a7f3359a56b54@172.13.0.6:30303"


if [ ! -d /qdata/dd/geth/chaindata ]; then
  echo "[*] Mining Genesis block"
  /usr/local/bin/geth --datadir /qdata/dd init /qdata/genesis.json
fi

# echo "[*] Starting Constellation node"
# nohup /usr/local/bin/constellation-node $TMCONF 2>> /qdata/logs/constellation.log &

echo "[*] Starting Tessera node"
java -jar /tessera/tessera-app.jar -configfile $TMCONF >> /qdata/logs/tessera.log 2>&1 &

sleep 50

echo "[*] Starting Geth node"
PRIVATE_CONFIG=/qdata/tm.ipc nohup /usr/local/bin/geth $GETH_ARGS 2>>/qdata/logs/geth.log