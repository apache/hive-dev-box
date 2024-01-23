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

# FIXME: partially duplicated from sokol

set -e

apt-get install -y zip unzip 
export SDKMAN_DIR="/usr/local/sdkman"

curl -s "https://get.sdkman.io" | bash
source "$SDKMAN_DIR/bin/sdkman-init.sh"

#sdk install java 7.0.222-zulu
sdk install java 8.0.222-zulu
#sdk install maven 3.6.1

cat > /etc/bashrc.d << EOF

export SDKMAN_DIR="/usr/local/sdkman"
#source "$HOME/.sdkman/bin/sdkman-init.sh"
source "$SDKMAN_DIR/bin/sdkman-init.sh"

function sw_j7() {
        sdk use java 7.0.222-zulu
}

function sw_j8() {
        sdk use java 8.0.212-zulu
}

EOF
