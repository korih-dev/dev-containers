#!/usr/bin/env bash
set -x

echo 'installing python 3.8'

apt-get update
apt-get install -y --no-install-recommends \
	python${PYTHON_VERSION} \
	python${PYTHON_VERSION}-dev

which python${PYTHON_VERSION}
return_code=$?
set -e

if [ $return_code != 0 ]; then
   echo "-- using deadsnakes ppa to install Python ${PYTHON_VERSION}"
   add-apt-repository ppa:deadsnakes/ppa
   apt-get update
   apt-get install -y --no-install-recommends \
	  python${PYTHON_VERSION} \
	  python${PYTHON_VERSION}-dev
fi

rm -rf /var/lib/apt/lists/*
apt-get clean

curl -sS https://bootstrap.pypa.io/get-pip.py | python${PYTHON_VERSION} || \
curl -sS https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3.6

ln -s /usr/bin/python${PYTHON_VERSION} /usr/local/bin/python3

which python3
python3 --version

which pip3
pip3 --version

python3 -m pip install --upgrade pip --index-url https://pypi.org/simple

pip3 install --no-cache-dir --verbose --no-binary :all: psutil
pip3 install --upgrade --no-cache-dir \
   setuptools \
   packaging \
   'Cython<3' \
   wheel \
   twine