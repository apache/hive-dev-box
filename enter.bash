#!/bin/bash -e

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[ "$1" == "" ] && echo "usage: $0 <container name>" && exit 1

DOCKER=docker
function isContainerRunning() {
    [ "`$DOCKER ps -q -f name=$1`" != "" ]
}

# FIXME: make this cleaner
if [ "$DISPLAY" != "" ];then
    echo " * enabling X forward..."
    if [ "`which sw_vers`" != "" ] ; then
        # MacOSX assumed
        xhost + 127.0.0.1
        RUN_OPTS+=" -e DISPLAY=host.docker.internal:0"
    else
        XSOCK=/tmp/.X11-unix
        XAUTH=/tmp/.docker.xauth
        touch $XAUTH
        xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
        RUN_OPTS+=" -e DISPLAY -e XAUTHORITY=$XAUTH -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH"
    fi
fi

#export HIVE_TEST_DOCKER_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.Gateway}}{{end}}' `hostname`)

isContainerRunning "$1" || docker start "$1"

docker exec -it "$1" /bin/bash -login

