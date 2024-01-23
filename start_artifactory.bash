#!/bin/bash

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

set -e

DOCKER=docker
function isContainerRunning() {
    [ "`$DOCKER ps -q -f name=$1`" != "" ]
}


if isContainerRunning artifactory; then
	echo "you already have a container named artifactory"
	echo "docker rm -f artifactory"
	echo "docker volume rm artifactory_data"
	exit 1
fi

IMAGE=docker.bintray.io/jfrog/artifactory-oss:6.23.41

docker pull $IMAGE


NET=hive-dev-box-net
docker network create hive-dev-box-net || true
RUN_OPTS+=" --name artifactory"
RUN_OPTS+=" --network $NET"
RUN_OPTS+=" -d --restart always"
RUN_OPTS+=" -v artifactory_data:/var/opt/jfrog/artifactory"
RUN_OPTS+=" -p 127.0.0.1:8081:8081"
docker run $RUN_OPTS $IMAGE

docker cp artifactory_backup.zip artifactory:/tmp/backup.zip
echo "@@@ artifactory should be running"

cat << EOF
===
To load remote repos/etc you will need to run below command after it have started up:

docker exec -it artifactory /bin/bash
curl -X POST -u admin:password -H "Content-type: application/json" http://localhost:8081/artifactory/ui/artifactimport/system \
  -d '{ "path":"/tmp/backup.zip","excludeContent":false,"excludeMetadata":false,"verbose":false,"zip":true,"action":"system"}'

# after executing the above command you will be able to log into artifactory by using: admin/admin
===
EOF

#
#curl -X POST -u admin:password1 -H "Content-type: application/json" -d '{ "userName" : "admin", "oldPassword" : "password1", "newPassword1" : "password", "newPassword2" : "password" }' http://localhost:8081/artifactory/api/security/users/authorization/changePassword
#

