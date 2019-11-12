#!/bin/bash

source ./env
rm -rf $TARGET_FOLDER 2> /dev/null

if [ ! -f $FILE ]; then
	wget -cO - http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/equinox/drops/R-4.13-201909161045/EclipseRT-OSGi-StarterKit-4.13-linux-gtk-x86_64.tar.gz > $FILE
fi

tar -zxf $FILE

mv $SOURCE_FOLDER $TARGET_FOLDER

pushd $TARGET_FOLDER
	mv $SOURCE_FOLDER.ini $TARGET_FOLDER.ini
	mv $SOURCE_FOLDER $TARGET_FOLDER
	sed -i '/console/d' ./$TARGET_FOLDER.ini
popd
