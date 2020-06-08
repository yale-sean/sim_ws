#!/bin/bash

# exit when any command fails
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WS_DIR=$DIR/../../../

# alphapose
${WS_DIR}/src/alphapose_ros/setup.sh

# openface
pushd ${WS_DIR}/src/openface2_wrapper
export LOCAL_INSTALL=`pwd`/libraries/local_install
mkdir -p $LOCAL_INSTALL
# openface models
pushd libraries/OpenFace
bash download_models.sh
popd
# opencv
pushd libraries/opencv
mkdir build; pushd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=${LOCAL_INSTALL} -D BUILD_TIFF=ON -D WITH_TBB=ON -D BUILD_SHARED_LIBS=OFF -D BUILD_opencv_cudacodec=ON ..
make -j 12 && make install
popd
popd
# dlib
pushd libraries/dlib
mkdir build; pushd build
cmake -D CMAKE_INSTALL_PREFIX=${LOCAL_INSTALL} -D DLIB_USE_CUDA=OFF ..
cmake --build . --config Release -- -j 12
make install
popd
# build openface
pushd libraries/OpenFace
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${LOCAL_INSTALL}/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${LOCAL_INSTALL}/lib/pkgconfig
export OpenCV_DIR=`pwd`/../opencv/build
export dlib_DIR=${LOCAL_INSTALL}/lib/cmake/dlib
mkdir build; pushd build
cmake -D CMAKE_BUILD_TYPE=RELEASE CMAKE_CXX_FLAGS="-std=c++11" -D CMAKE_EXE_LINKER_FLAGS="-std=c++11" -D CMAKE_INSTALL_PREFIX=${LOCAL_INSTALL} ..
make -j 12
make install
popd
popd
# test
#pushd libraries/local_install/bin
# ./FaceLandmarkVid -f "../../OpenFace/samples/changeLighting.wmv"

popd # end openface
