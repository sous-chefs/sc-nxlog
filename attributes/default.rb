#
# Cookbook Name:: nxlog
# Attributes:: default
#
# Copyright 2014, Symbols Worldwide Ltd.
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

default['nxlog']['version'] = '2.9.1347'

default['nxlog']['log_level'] = 'INFO'
default['nxlog']['user'] = 'nxlog'
default['nxlog']['group'] = 'nxlog'

case node['platform_family']
when 'debian'
  default['nxlog']['conf_dir'] = '/etc/nxlog'
  default['nxlog']['log_file'] = '/var/log/nxlog/nxlog.log'
when 'rhel'
  default['nxlog']['conf_dir'] = '/etc'
  default['nxlog']['log_file'] = '/var/log/nxlog/nxlog.log'
when 'windows'
  if node['kernel']['machine'] == 'x86_64'
    root_dir = 'c:/Program Files (x86)/nxlog'
  else
    root_dir = 'c:/Program Files/nxlog'
  end

  default['nxlog']['root_dir'] = root_dir
  default['nxlog']['conf_dir'] = "#{root_dir}/conf"
  default['nxlog']['log_file'] = "#{root_dir}/nxlog.log"
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end

default['nxlog']['papertrail']['bundle_url'] =
  'https://papertrailapp.com/tools/papertrail-bundle.pem'
