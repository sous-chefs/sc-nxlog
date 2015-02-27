#
# Cookbook Name:: nxlog_ce
# Provider:: log_destination
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

def config_filename(name)
  "#{node['nxlog_ce']['conf_dir']}/nxlog.conf.d/op_#{name}.conf"
end

action :create do
  converge_by("Create #{new_resource}") do
    n = new_resource

    # common parameters
    params = []
    params << ['Module', n.module]
    params << ['Exec', n.exec] if n.exec
    params << ['OutputType', n.output_type] if n.output_type

    # module-specific parameters
    case n.module
    when 'om_dbi'
      params << ['Driver', n.driver]
      params << ['SQL', n.sql]
      n.options.each do |option|
        params << ['Option', option]
      end

    when 'om_blocker'
      # nothing to do!

    when 'om_exec'
      params << ['Command', n.command]
      n.args.each do |arg|
        params << ['Arg', arg]
      end

    when 'om_file'
      params << ['CreateDir', n.create_dir] unless n.create_dir.nil?
      params << ['Truncate', n.truncate] unless n.truncate.nil?
      params << ['Sync', n.sync] unless n.sync.nil?
      params << ['File', n.file =~ /["']/ ? n.file : "\"#{n.file}\""]

    when 'om_http'
      params << ['Url', n.url]
      params << ['ContentType', n.content_type] if n.content_type

      params << ['HTTPSCertFile',
                 n.https_cert_file] if n.https_cert_file
      params << ['HTTPSCertKeyFile',
                 n.https_cert_key_file] if n.https_cert_key_file
      params << ['HTTPSKeyPass',
                 n.https_key_pass] if n.https_key_pass
      params << ['HTTPSCAFile',
                 n.https_ca_file] if n.https_ca_file
      params << ['HTTPSCADir',
                 n.https_ca_dir] if n.https_ca_dir
      params << ['HTTPSCRLFile',
                 n.https_crl_file] if n.https_crl_file
      params << ['HTTPSCRLDir',
                 n.https_crl_dir] if n.https_crl_dir

      params << ['HTTPSAllowUntrusted',
                 n.https_allow_untrusted] unless n.https_allow_untrusted.nil?

    when 'om_null'
      # nothing to do!

    when 'om_ssl'
      params << ['Host', n.host]
      params << ['Port', n.port]
      params << ['CertFile', n.cert_file]
      params << ['CertKeyFile', n.cert_key_file]
      params << ['KeyPass', n.key_pass]
      params << ['CAFile', n.ca_file]
      params << ['CADir', n.ca_dir]
      params << ['CRLFile', n.crl_file]
      params << ['CRLDir', n.crl_dir]
      params << ['AllowUntrusted', n.allow_untrusted]

    when 'om_tcp', 'om_udp'
      params << ['Host', n.host]
      params << ['Port', n.port]
      params << ['SockBufSize', n.sock_buf_size]

    when 'om_uds'
      params << ['UDS', n.uds]

    else
      fail 'Tried to write nxlog config for unrecognised output module: ' +
        n.module

    end

    # create template with above parameters
    template config_filename(n.name) do
      cookbook n.cookbook_name.to_s
      source 'resources/destination.conf.erb'
      variables name: n.name, params: params
    end
  end
end

action :delete do
  converge_by("Delete #{new_resource}") do
    template config_filename(new_resource.name) do
      cookbook new_resource.cookbook_name.to_s
      source 'resources/destination.conf.erb'
      action :delete
    end
  end
end
