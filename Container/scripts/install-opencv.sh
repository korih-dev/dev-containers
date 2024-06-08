#!/usr/bin/env bash
set -e -x

echo "Installing dependencies for opencv ${OPENCV_VERSION}"

apt-get update
apt-get install -y --no-install-recommends \
        build-essential \
	   gfortran \
        cmake \
        git \
	   file \
	   tar \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libcanberra-gtk3-module \
        libeigen3-dev \
        libglew-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer1.0-dev \
        libgtk-3-dev \
        libjpeg-dev \
        libjpeg8-dev \
        libjpeg-turbo8-dev \
        liblapack-dev \
        liblapacke-dev \
        libopenblas-dev \
        libpng-dev \
        libpostproc-dev \
        libswscale-dev \
        libtbb-dev \
        libtbb2 \
        libtesseract-dev \
        libtiff-dev \
        libv4l-dev \
        libxine2-dev \
        libxvidcore-dev \
        libx264-dev \
	   libgtkglext1 \
	   libgtkglext1-dev \
        pkg-config \
        qv4l2 \
        v4l-utils \
        zlib1g-dev \
        libavresample-dev \
        libdc1394-22-dev

apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-distutils \
    python3-setuptools

rm -rf /var/lib/apt/lists/*
apt-get clean

echo "Downloading opencv ${OPENCV_VERSION}"

python3 -c "import cv2; print('OpenCV version:', str(cv2.__version__)); print(cv2.getBuildInformation())"

set -e

# remove previous OpenCV installation if it exists
apt-get purge -y '.*opencv.*' || echo "previous OpenCV installation not found"

# download and extract the deb packages
mkdir opencv
cd opencv
wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${OPENCV_URL} -O ${OPENCV_DEB}
tar -xzvf ${OPENCV_DEB}

# install the packages and their dependencies
dpkg -i --force-depends *.deb
apt-get update 
apt-get install -y -f --no-install-recommends
dpkg -i *.deb
rm -rf /var/lib/apt/lists/*
apt-get clean

# remove the original downloads
cd ../
rm -rf opencv

# manage some install paths
PYTHON3_VERSION=`python3 -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'`

if [ $ARCH = "aarch64" ]; then
	local_include_path="/usr/local/include/opencv4"
	local_python_path="/usr/local/lib/python${PYTHON3_VERSION}/dist-packages/cv2"

	if [ -d "$local_include_path" ]; then
		echo "$local_include_path already exists, replacing..."
		rm -rf $local_include_path
	fi
	
	if [ -d "$local_python_path" ]; then
		echo "$local_python_path already exists, replacing..."
		rm -rf $local_python_path
	fi
	
	ln -s /usr/include/opencv4 $local_include_path
	ln -s /usr/lib/python${PYTHON3_VERSION}/dist-packages/cv2 $local_python_path

set -ex
pip3 install --no-cache-dir --verbose opencv-contrib-python~=${OPENCV_VERSION}