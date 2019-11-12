#/bin/bash

source ./env

# Prepare server
./deploy.sh

# Compile app
DIR=$(pwd)
pushd ../../tycho/dependencies/
	mvn clean install
	cp bundles/com.geodb.tycho.activator/target/*.jar $DIR/$TARGET_FOLDER/plugins/app.jar
	mvn clean
popd

sed -i '/osgi.bundles=/ s/$/,reference\\:file\\:app.jar@start/' $TARGET_FOLDER/configuration/config.ini
