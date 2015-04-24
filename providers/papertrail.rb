#
# Cookbook Name:: nxlog
# Provider:: papertrail
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

def whyrun_supported?
  true
end

action :create do
  converge_by("Create #{new_resource}") do
    n = new_resource

    nxlog_destination n.name do
      action :create
      output_module 'om_ssl'
      host "#{n.host}.papertrailapp.com"
      port n.port
      ca_file ::File.join(node['nxlog']['conf_dir'], 'certs',
                          'papertrail-bundle.pem')
      allow_untrusted false
      exec '$Hostmame = hostname(); to_syslog_ietf();'
      default n.default
    end
  end
end

action :delete do
  converge_by("Delete #{new_resource}") do
    n = new_resource

    nxlog_destination n.name do
      action :delete
      output_module 'om_ssl'
      host "#{n.host}.papertrailapp.com"
      port n.port
      ca_file ::File.join(node['nxlog']['conf_dir'], 'certs',
                          'papertrail-bundle.pem')
      allow_untrusted false
      exec '$Hostmame = hostname(); to_syslog_ietf();'
      default n.default
    end
  end
end
