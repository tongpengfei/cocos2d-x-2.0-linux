#!/bin/bash

TXTCOLOR_DEFAULT="\033[0;m"
TXTCOLOR_RED="\033[0;31m"
TXTCOLOR_GREEN="\033[0;32m"


if [ -z $1 ]; then
	echo -e $TXTCOLOR_RED"require a argument: ./linux-patch.sh cocos2d-x-2.0-path"$TXTCOLOR_DEFAULT;
	exit 1
fi

COCOS2DX20_TRUNK=`pwd`/$1
PATCH_TRUNK=`pwd`
echo -e $PATCH_TRUNK $COCOS2DX20_TRUNK

DEPENDS='libx11-dev'
DEPENDS+=' libxmu-dev'
DEPENDS+=' libglu1-mesa-dev'
DEPENDS+=' libgl2ps-dev'
DEPENDS+=' libxi-dev'
DEPENDS+=' libglfw-dev'
DEPENDS+=' g++'
DEPENDS+=' libzip-dev'
for i in $DEPENDS
do
	echo -e $TXTCOLOR_GREEN"sudo apt-get install $i, please enter your password:"$TXTCOLOR_DEFAULT
	sudo apt-get install $i
done

#echo $TXTCOLOR_GREEN"sudo apt-get install cmake"$TXTCOLOR_DEFAULT;
#sudo apt-get install cmake

#cd ./cocos2dx/platform/third_party/linux/libtiff
#echo -e $TXTCOLOR_GREEN"downloading libtiff ..."$TXTCOLOR_DEFAULT;
#wget http://download.osgeo.org/libtiff/tiff-4.0.1.tar.gz

#echo -e $TXTCOLOR_GREEN"building libtiff ..."$TXTCOLOR_DEFAULT;
#tar -zxf tiff-4.0.1.tar.gz
#cd ./tiff-4.0.1
#./configure && make 
#cd $PATCH_TRUNK

echo -e $TXTCOLOR_GREEN"cp $PATCH_TRUNK/* $COCOS2DX20_TRUNK/ -rf"$TXTCOLOR_DEFAULT;
cp $PATCH_TRUNK/* $COCOS2DX20_TRUNK/ -rf

cd $COCOS2DX20_TRUNK/cocos2dx/platform/third_party/linux/glew-1.7.0/
echo -e $TXTCOLOR_GREEN"building glew-1.7.0 ..."$TXTCOLOR_DEFAULT;
tar -zxf glew-1.7.0.tgz
make -C ./glew-1.7.0/
cd -

cd $COCOS2DX20_TRUNK/js/spidermonkey-linux
echo -e $TXTCOLOR_GREEN"building spidermonkey ..."$TXTCOLOR_DEFAULT;
tar -zxf js185-1.0.0.tar.gz
cd ./js-1.8.5/js/src
./configure && make

OUTPUT_DEBUG=$COCOS2DX20_TRUNK/lib/linux/Debug/

make -C $COCOS2DX20_TRUNK/Box2D/proj.linux
cp $COCOS2DX20_TRUNK/Box2D/proj.linux/libbox2d.a $OUTPUT_DEBUG

make -C $COCOS2DX20_TRUNK/chipmunk/proj.linux
cp $COCOS2DX20_TRUNK/chipmunk/proj.linux/libchipmunk.a $OUTPUT_DEBUG

make -C $COCOS2DX20_TRUNK/cocos2dx/proj.linux
cp $COCOS2DX20_TRUNK/cocos2dx/proj.linux/libcocos2d.so $OUTPUT_DEBUG

make -C $COCOS2DX20_TRUNK/CocosDenshion/proj.linux
cp $COCOS2DX20_TRUNK/CocosDenshion/proj.linux/libcocosdenshion.so $OUTPUT_DEBUG

make -C $COCOS2DX20_TRUNK/tests/proj.linux
make -C $COCOS2DX20_TRUNK/HelloWorld/Linux

make -C $COCOS2DX20_TRUNK/testjs/proj.linux

cd $COCOS2DX20_TRUNK/tests/proj.linux
./cocos2dx-test
cd -
