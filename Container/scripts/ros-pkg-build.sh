# # install dependencies using rosdep
# rosdep init
# rosdep update
# rosdep install -y \
# 	--ignore-src \
# 	--from-paths src \
# 	--rosdistro ${ROS_DISTRO} \
# 	--skip-keys "$SKIP_KEYS"

# colcon build \
# 	--merge-install \
# 	--cmake-args -DCMAKE_BUILD_TYPE=Release 

# # remove build files
# rm -rf ${ROS_ROOT}/src
# rm -rf ${ROS_ROOT}/logs
# rm -rf ${ROS_ROOT}/build
# rm ${ROS_ROOT}/*.rosinstall

# source.. "$ROS_ROOT/install/setup.bash"