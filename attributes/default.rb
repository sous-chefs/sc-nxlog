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

default['nxlog']['checksums']['nxlog-ce-2.9.1347-1_rhel6.x86_64.rpm'] =
  '1d86249c306f284d9b040d6eba02248126889f30fba8efabefe81e2a0a54846b'
default['nxlog']['checksums']['nxlog-ce-2.9.1347-1_rhel7.x86_64.rpm'] =
  '6d18081e31acd968bffceabec56b157706837562dc8e22bd294228883118baca'
default['nxlog']['checksums']['nxlog-ce_2.9.1347_debian_jessie_amd64.deb'] =
  '59819367ca6c44dd699d4db8ca1b7139f81ce777332821c12eb6e42767713560'
default['nxlog']['checksums']['nxlog-ce_2.9.1347_debian_squeeze_amd64.deb'] =
  '5404954f431826fbc8adc81b2187d43a3d43daec92812d200457e19d6e6f0056'
default['nxlog']['checksums']['nxlog-ce_2.9.1347_debian_wheezy_amd64.deb'] =
  'cfc77f71ceb8604bd745ace439e02bc949ae611b5e9bd9fd6cef100b092e64da'
default['nxlog']['checksums']['nxlog-ce-2.9.1347.msi'] =
  '930148e3bb4501adf3a78b4d3417d9165dffa0e3215b8a26fea9f1c27f0978b6'
default['nxlog']['checksums']['nxlog-ce_2.9.1347_ubuntu_1204_amd64.deb'] =
  '0dd942ee06c8c364e7c929102ae0a6174ddc2e3c6e9a9fe863f5b94bdb93da3c'
default['nxlog']['checksums']['nxlog-ce_2.9.1347_ubuntu_1404_amd64.deb'] =
  '67d17bc3f6e49a4b4df67a630b58dcb08fda287af3f02e47048b67845665c028'

default['nxlog']['papertrail']['bundle_url'] =
  'https://papertrailapp.com/tools/papertrail-bundle.pem'
