#
# Cookbook Name:: nxlog-ce
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

default['nxlog-ce']['version'] = '2.8.1248'

default['nxlog-ce']['log_level'] = 'INFO'
default['nxlog-ce']['user'] = 'nxlog'
default['nxlog-ce']['group'] = 'nxlog'

case node['platform_family']
when 'debian'
  default['nxlog-ce']['conf_dir'] = '/etc/nxlog'
  default['nxlog-ce']['log_file'] = '/var/log/nxlog/nxlog.log'
when 'rhel'
  default['nxlog-ce']['conf_dir'] = '/etc/'
  default['nxlog-ce']['log_file'] = '/var/log/nxlog/nxlog.log'
when 'windows'
  root_dir = node['kernel']['machine'] == 'x86_64' ? 'c:/Program Files (x86)/nxlog' : 'c:/Program Files/nxlog'
  default['nxlog-ce']['root_dir'] = root_dir
  default['nxlog-ce']['conf_dir'] = "#{root_dir}/conf"
  default['nxlog-ce']['log_file'] = "#{root_dir}/nxlog.log"
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end
