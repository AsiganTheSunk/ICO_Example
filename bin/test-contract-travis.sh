#!/bin/bash

set -e

ganache-cli -d -p 8545 --defaultBalanceEther 10000 --gasLimit 10000000 -a 30 --noVMErrorsOnRPCResponse 2> /dev/null 1> /dev/null &
sleep 5 # to make sure ganache-cli is up and running before compiling
rm -rf build
truffle compile
truffle migrate --reset --network development
truffle test
kill -9 $(lsof -t -i:8545)
