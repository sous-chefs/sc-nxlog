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

package 'libapr1'

if node['platform_version'].to_f >= 8.0
  suffix = '_debian_jessie'
  package 'libperl5.20'
  package 'libdbi1'
elsif node['platform_version'].to_f >= 7.0
  suffix = '_debian_wheezy'
  package 'libperl5.14'
  package 'libdbi1'
else
  suffix = '_debian_squeeze'
  package 'libperl5.10'
  package 'libdbi0'
end

package_name = "nxlog-ce_#{node['nxlog']['version']}#{suffix}_amd64.deb"

node.default['nxlog']['installer_package'] = package_name
