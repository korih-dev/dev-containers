#!/usr/bin/env bash
set -ex

echo 'installing protobuff'

apt-get update
apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \ 
    automake \
    libtool \
    zip \
    unzip
rm -rf /var/lib/apt/lists/*
apt-get clean

pip3 install --no-cache-dir tzdata
cd /tmp
wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${PROTOBUF_URL}/$PROTOBUF_DIR.zip
wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${PROTOBUF_URL}/$PROTOC_DIR.zip
unzip ${PROTOBUF_DIR}.zip -d ${PROTOBUF_DIR}
unzip ${PROTOC_DIR}.zip -d ${PROTOC_DIR}
cp ${PROTOC_DIR}/bin/protoc /usr/local/bin/protoc
cd ${PROTOBUF_DIR}/protobuf-${PROTOBUF_VERSION}
./autogen.sh
./configure --prefix=/usr/local
make -j$(nproc)
make check -j$(nproc)
make install
ldconfig
cd python
python3 setup.py build --cpp_implementation
python3 setup.py test --cpp_implementation
python3 setup.py bdist_wheel --cpp_implementation 
cp dist/*.whl /opt
pip3 install /opt/protobuf*.whl 
cd ../../../ 
rm ${PROTOBUF_DIR}.zip 
rm ${PROTOC_DIR}.zip 
rm -rf ${PROTOBUF_DIR} 
rm -rf ${PROTOC_DIR}

RUN pip3 show protobuf && protoc --version