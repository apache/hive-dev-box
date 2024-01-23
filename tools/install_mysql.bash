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
apt-get install -y mariadb-server default-mysql-client

sudo mysql << EOF
DROP DATABASE IF EXISTS metastore;
DROP USER IF EXISTS 'hive'@'localhost';
create database metastore;
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'mypassword';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'localhost';
GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'localhost';
FLUSH PRIVILEGES;
EOF

cat > ~vagrant/.my.cnf << EOF
[client]
user=hive
password=mypassword
database=metastore
EOF

mkdir -p /apps/lib
cd /apps/lib
[ ! -f mysql-connector-java-8.0.17.jar ] && wget -nv https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.17/mysql-connector-java-8.0.17.jar
