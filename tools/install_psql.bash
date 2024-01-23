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

sudo apt-get install -y postgresql
sudo -u postgres psql -c "CREATE USER hiveuser WITH PASSWORD 'mypassword'"
sudo -u postgres createdb metastore -O hiveuser

# FIXME use dev instead of vagrant
echo localhost:5432:metastore:hiveuser:mypassword > ~vagrant/.pgpass
chown vagrant ~vagrant/.pgpass
chmod 600 ~vagrant/.pgpass

cat > /etc/profile.d/postgres_def.sh <<EOF
export PGHOST=localhost
export PGUSER=hiveuser
export PGDATABASE=metastore
EOF
