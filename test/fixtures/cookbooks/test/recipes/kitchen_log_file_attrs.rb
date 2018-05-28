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

# create the resources from the node attributes, restart and wait

include_recipe 'sc-nxlog::default'
include_recipe 'sc-nxlog::papertrail'

# wait for the mark to appear in the log output by explicitly starting nxlog
# and waiting for a set time
service 'nxlog_restart' do
  service_name 'nxlog'
  action :restart
end

ruby_block 'sleep' do
  block do
    sleep 70
  end
  action :run
end
