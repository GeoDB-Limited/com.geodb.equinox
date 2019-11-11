#!/bin/bash

source ./env

pushd $TARGET_FOLDER
	nohup ./$TARGET_FOLDER -console $PORT > /dev/null 2>&1 &
popd
