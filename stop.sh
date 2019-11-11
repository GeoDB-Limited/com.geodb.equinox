#!/bin/bash

source ./env

(
echo "open localhost 5555"
sleep 2
echo "shutdown"
sleep 2
) | telnet
