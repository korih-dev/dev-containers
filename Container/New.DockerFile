FROM Jetson:latest

# source ros installation or smth
ENTRYPOINT [ "ros2 launch " ]

# sudo docker run --runtime nvidia -it --rm --network=host custom_container -v /dir/:/dir/