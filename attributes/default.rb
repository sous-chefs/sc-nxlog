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

default['nxlog']['version'] = '2.9.1504'

default['nxlog']['log_level'] = 'INFO'
default['nxlog']['user'] = 'nxlog'
default['nxlog']['group'] = 'nxlog'

default['nxlog']['package_source'] = 'https://mirror.widgit.com/nxlog'

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

default['nxlog']['checksums']['nxlog-ce-2.9.1504-1_rhel6.x86_64.rpm'] =
  'c58858e82202cbb0c78c78e90058d57bf4f1e136bc6335916bcf45789ca9b153'
default['nxlog']['checksums']['nxlog-ce-2.9.1504-1_rhel7.x86_64.rpm'] =
  '095adf02c3d93c7358a9c1a4e601529d8773714310ad4df3117585c48a2ac7a6'
default['nxlog']['checksums']['nxlog-ce_2.9.1504.deb'] =
  '16996f4bc56a46bd1b186b52f903f5fe4be11b92cf3560171ba134c400295a06'
default['nxlog']['checksums']['nxlog-ce_2.9.1504_debian_squeeze_amd64.deb'] =
  'da5e2712a9a045af345fcb9e92406cdace2c6e1b1d40c5fb458e23548322c0e3'
default['nxlog']['checksums']['nxlog-ce_2.9.1504_debian_wheezy_amd64.deb'] =
  'cfd76a6fcacc53c4a2172393ef7ca751439892feff26f949444606c16e28025f'
default['nxlog']['checksums']['nxlog-ce-2.9.1504.msi'] =
  'd49b7bf1a631361dc2b701848bd370668bb08d11bd869c2c48c7a31e21b3c154'
default['nxlog']['checksums']['nxlog-ce_2.9.1504_ubuntu_1204_amd64.deb'] =
  '5908a1efcfc87830eb03f3f08f00576aa98950e41ec11b96f9491e02f0d130c9'
default['nxlog']['checksums']['nxlog-ce_2.9.1504_ubuntu_1404_amd64.deb'] =
  'f5342194fa0938c9a604b0a6f3d58c247cd0a8feae8f4fb8d8863f946d667f13'

default['nxlog']['papertrail']['bundle_url'] =
  'https://papertrailapp.com/tools/papertrail-bundle.pem'
