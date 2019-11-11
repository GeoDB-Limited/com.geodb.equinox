#!/bin/bash

source ./env

(
echo "open localhost $PORT"
sleep 2
echo "shutdown"
sleep 2
) | telnet
