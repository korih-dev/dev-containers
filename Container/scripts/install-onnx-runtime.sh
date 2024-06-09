#!/usr/bin/env bash
set -ex

tarpack install onnxruntime-gpu-${ONNXRUNTIME_VERSION}
pip3 install --no-cache-dir --verbose onnxruntime-gpu==${ONNXRUNTIME_VERSION}

python3 -c 'import onnxruntime; print(onnxruntime.__version__);'