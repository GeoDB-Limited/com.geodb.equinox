#/bin/bash

source ./env

# Prepare server
./deploy.sh

# Compile app
DIR=$(pwd)
pushd ../../tycho/dependencies/
	mvn clean install
	cp bundles/com.geodb.tycho.activator/target/*.jar $DIR/app.jar
	mvn clean
popd

# Start server
./start.sh

# Install app
(
echo "open localhost $PORT"
sleep 2
echo "cd .."
sleep 2
echo "install app.jar"
sleep 2
echo "disconnect"
sleep 2
) | telnet

# Start bundle
(
echo "open localhost $PORT"
sleep 2
echo "start 53"
sleep 2
echo "disconnect"
sleep 2
) | telnet

