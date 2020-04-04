FROM osrf/ros:melodic-desktop-full

RUN apt-get update -y && \
    apt-get install -y \
                git \
                python-pip \
                wget \
                libgeographic-dev \
                ros-melodic-geographic-msgs \
                ros-melodic-joy \
                ros-melodic-octomap-ros \
                ros-melodic-mavlink \
                python-wstool \
                python-catkin-tools \
                protobuf-compiler \
                libgoogle-glog-dev \
                ros-melodic-control-toolbox && \
    pip install \
                pynput \
                future \
                python-uinput \
                pygame && \
    rm /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep fix-permissions && \
    rosdep init ; \
    rosdep update && \
    mkdir -p /ros_ws/src && \
    cd /ros_ws/src && \
    catkin_init_workspace ; \
    wstool init && \
    wget --no-cache https://raw.githubusercontent.com/pablo709/rotors_simulator/master/rotors_hil.rosinstall && \
    wstool merge rotors_hil.rosinstall && \
    wstool update && \
    /bin/bash -c "source /opt/ros/melodic/setup.bash && \
    cd /ros_ws && \
    sed -i 's/msg\.twist_covariance/msg.velocity_covariance/g' src/mavros/mavros_extras/src/plugins/odom.cpp && \
    catkin build"

RUN sed -i 's/\/home\/pablo\/Documentos\/UTN\/proyecto\/ros_sim//g' /ros_ws/src/rotors_simulator/rotors_description/urdf/kamikaze_liftDrag_path.xacro && \
    sed -i '5d' /ros_entrypoint.sh && \
    sed -i '5isource /ros_ws/devel/setup.bash' /ros_entrypoint.sh
 
ENTRYPOINT ["/ros_entrypoint.sh"]
