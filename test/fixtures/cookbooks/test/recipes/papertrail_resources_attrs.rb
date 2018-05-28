#
# Cookbook Name:: nxlog
# Recipe:: default
#
# Copyright (C) 2014 Simon Detheridge
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# creates the same resources as test_default_resources, but as node attributes

node.override['nxlog'] = JSON.parse(<<EOT)
{
  "papertrails": {
    "my_papertrail": {
      "port": 11111
    },
    "my_papertrail_2": {
      "port": 11111,
      "host": "logs2"
    }
  }
}
EOT

include_recipe 'sc-nxlog::default'
include_recipe 'sc-nxlog::papertrail'
