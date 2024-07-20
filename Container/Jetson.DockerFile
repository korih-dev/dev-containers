# cuda enabled openCV for C++???
# cmake pip vs cmake apt???
# onnx only pip?
# so is onnxruntime
# so is zed

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml
# JetPack 5.1.1 (L4T R35.3.1)
# l4t-ml:r35.3.1-py3
    # TensorFlow 2.11.0
    # PyTorch v2.0.0
    # torchvision v0.15.1
    # torchaudio v2.0.1
    # onnx 1.13.1
    # onnxruntime 1.16.0
    # optimum 1.8.8
    # CuPy 13.0.0
    # numpy 1.23.5
    # numba 0.56.4
    # PyCUDA 2022.2
    # OpenCV 4.5.0 (with CUDA)
    # pandas 2.0.1
    # scipy 1.10.0
    # scikit-learn 1.2.2
    # diffusers 0.17.1
    # transformers 4.30.2
    # xformers 0.0.20
    # JupyterLab 3.6.3

    # sudo docker run -it --rm --runtime nvidia --network host -v /home/user/project:/location/in/container nvcr.io/nvidia/l4t-ml:r35.2.1-py3


# docker pull nvcr.io/nvidia/l4t-jetpack:r35.3.1
FROM jetpack:latest

# not sure if cuda version is matched... https://github.com/dusty-nv/jetson-containers/blob/master/packages/cuda/cuda/config.py
ENV CUDA_VERSION=12.2.0 
ENV CUDNN_VERSION=8.5 
# cudnn might be wrong.... verify when you check the l4t container just make sure the jetpack version and L4T tag is the same
ENV TENSORRT_VERSION=8.6
ENV PIP_INDEX_URL=N/A
ENV JETPACK_VERSION=5.1.1
ENV L4T_VERSION=35.3.1

COPY . /scripts

RUN apt -y update && apt -y upgrade

# build-essential
ENV DEBIAN_FRONTEND=noninteractive \
    LANGUAGE=en_US:en \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN /scripts/build-essential.sh

COPY /scripts/tarpack /usr/local/bin/

# python 3.8.10
ENV PYTHON_VERSION=3.8 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=utf-8 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_CACHE_PURGE=true \
    PIP_ROOT_USER_ACTION=ignore \
    TWINE_NON_INTERACTIVE=1 \
    DEBIAN_FRONTEND=noninteractive

RUN /scripts/install-python.sh

# numpy
ENV OPENBLAS_CORETYPE=ARMV8

RUN pip3 install --upgrade --no-cache-dir --verbose numpy && \
    pip3 show numpy && python3 -c 'import numpy; print(numpy.__version__)'

# opencv-cuda
ENV OPENCV_URL=https://nvidia.box.com/shared/static/ngp26xb9hb7dqbu6pbs7cs9flztmqwg0.gz \
    OPENCV_VERSION=4.8.1 \
    OPENCV_DEB=OpenCV-4.8.1-aarch64.tar.gz

RUN /scripts/install-opencv-cuda.sh

# cmake_apt
RUN /scripts/install-cmake.sh

# onnx
RUN pip3 install --no-cache-dir --verbose onnx || \
    pip3 install --no-cache-dir --verbose git+https://github.com/onnx/onnx@main && \
    pip3 show onnx && \
    python3 -c 'import onnx; print(onnx.__version__)'

# onnxruntime 1.16.3
# probably need more flags, rn dont have the backup for building.sh

# onnxruntime_BUILD_UNIT_TESTS=OFF \
#         --cuda_home /usr/local/cuda --cudnn_home /usr/lib/$(uname -m)-linux-gnu \
#         --use_tensorrt --tensorrt_home /usr/lib/$(uname -m)-linux-gnu
ENV ONNXRUNTIME_VERSION=1.16.3 \
    ONNXRUNTIME_BRANCH=v1.16.3 \
    ONNXRUNTIME_FLAGS=--allow_running_as_root

RUN /scripts/install-onnxruntime.sh

# protobuff_cpp
ENV PROTOBUF_VERSION=3.20.3
ENV PROTOBUF_URL=https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3
ENV PROTOBUF_DIR=protobuf-python-3.20.3
ENV PROTOC_DIR=protoc-3.20.3-linux-aarch_64
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp

RUN /scripts/install-protobuf-cpp.sh

# zed
ENV L4T_MAJOR_VERSION=35
ENV L4T_MINOR_VERSION=3
ENV L4T_PATCH_VERSION=1
ENV ZED_SDK_MAJOR=4
ENV ZED_SDK_MINOR=0
ENV LOGNAME=root
ENV DEBIAN_FRONTEND=noninteractive

# ros2
ENV ROS_DISTRO=foxy
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PACKAGE=ros_base
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

RUN /scripts/install-ros2.sh

# will likely need to add to bashrc before using, steps for python to do that?, or just try running hello world example first

# jtop
RUN pip3 install -U jetson-stats

# sudo docker run --runtime nvidia -it --rm --network=host custom_container -v /dir/:/dir/
# ENTRYPOINT [ "ros2 launch " ]

# build-essential
# python3.8.10
# numpy
# opencv-cuda
# cmake_pip
# onnx
# ros-foxy
# onnxruntime 1.16.3
# protobuff_apt
# zed
# torch
# torchvision
# torch2trt/tf2trt
# cuda python/pycuda ? -> 11.4
# l4t-ML -> contains scipy, sci-kit learn, pandas
# numba
# cuda-python instead of cupy
# pycuda