#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt install -y git libboost-all-dev libboost-geometry-utils-perl libboost-system-dev libboost-thread-dev git-core build-essential libwxgtk3.0-dev libgtk-3-dev libwx-perl libmodule-build-perl libnet-dbus-perl cpanminus gcc-4.7 g++-4.7 libwx-perl libperl-dev libextutils-cppguess-perl libeigen3-dev libglew-dev cpanminus libcurl4-openssl-dev
sudo cpan ExtUtils::CBuilder ExtUtils::CppGuess Alien::wxWidgets CPAN::Mini  ExtUtils::XSpp::Cmd  ExtUtils::Typemaps::Basic

SLIC3R_REPO="https://github.com/alexrj/Slic3r.git"
SLIC3R_VERSION="master"
SLIC3R_DIR=~/Slic3r

sudo rm -rf ${SLIC3R_DIR}
git clone ${SLIC3R_REPO} ${SLIC3R_DIR}
cd ${SLIC3R_DIR}
git fetch ${SLIC3R_REPO}
git checkout ${SLIC3R_VERSION}
perl Build.PL --sudo
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release #-DSLIC3R_WX_STABLE=1 #maybe need to use this option by uncommenting
sudo make -j2
ctest --verbose
cd ..
./slic3r.pl --help
