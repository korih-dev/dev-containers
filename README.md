# Github Actions CI/CD Testing
shoving data into pipes

executing functional/unit tests before merge accepted make github repo for sample actions and test container registry GitHub actions for testing successful build buy running test pub sub also for making multi platform images executes succesful build and puts into repository

PyTorch/Tensorflow: build-essential python3.8.10 numpy opencv-cuda cmake_pip onnx ros-foxy onnxruntime 1.16.3 protobuff_apt zed torch torchvision l4t-pytorch? l4t-tensorflow (tensorflow2 built in) torch2trt/tf2trt cuda python/pycuda ? -> 11.4 l4t-ML -> contains scipy, sci-kit learn, pandas numba cuda-python instead of cupy pycuda

pip server for pre-built wheels docker tag 123456789abc JetPack-L4T:latest docker build -t my_jetson_test . i think we need to run this script on ubuntu on laptop.... --platform=arm64, x86, ... how to build using github actions if need GPU machine? -> maybe we make gitub actions use jetson as build server

sudo docker run --runtime nvidia -it --rm --network=host custom_container -v /dir/:/dir/

cuda enabled openCV for C++??? cmake pip vs cmake apt???

onnx only pip? so is onnxruntime so is zed

pipeline: run test.sh to verify successful installation at each section building, testing, publishing docker image based on repository files

add arg to add, default is all no --rm when running!! ENTRYPOINT ["ROS2 launch {ARG}"]

first attempt: try copying ros foxy installation instructions and hello world test
