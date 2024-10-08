#!/bin/bash
set -e

mkdir build
cd build

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  GTEST_ROOT_DIR=$PREFIX
else
  GTEST_ROOT_DIR=""
fi

### Create Makefiles
cmake ${CMAKE_ARGS} \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_EXAMPLES=OFF \
      -DGTEST_ROOT=$GTEST_ROOT_DIR \
      $SRC_DIR

### Build
cmake --build . -- -j${CPU_COUNT}

### Run all tests
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  cmake --build . -- test
fi

### Install
cmake --build . -- install
