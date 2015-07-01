#
# Cookbook Name:: nxlog
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
  "#{node['nxlog']['conf_dir']}/nxlog.conf.d/10_op_#{name}.conf"
end

def default_filename(name)
  "#{node['nxlog']['conf_dir']}/nxlog.conf.d/op_#{name}.default"
end

action :create do
  converge_by("Create #{new_resource}") do
    n = new_resource

    # common parameters
    params = []
    params << ['Module', n.output_module]
    params << ['Exec', n.exec] if n.exec
    params << ['OutputType', n.output_type] if n.output_type

    # module-specific parameters
    case n.output_module
    when 'om_dbi'
      params << ['Driver', n.driver]
      params << ['SQL', n.sql]
      unless n.options.nil?
        n.options.each do |option|
          params << ['Option', option]
        end
      end

    when 'om_blocker'
      # nothing to do!

    when 'om_exec'
      params << ['Command', n.command]
      unless n.args.nil?
        n.args.each do |arg|
          params << ['Arg', arg]
        end
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

      unless n.https_allow_untrusted.nil?
        params << ['HTTPSAllowUntrusted', n.https_allow_untrusted.to_s.upcase]
      end

    when 'om_null'
      # nothing to do!

    when 'om_ssl'
      params << ['Host', n.host]
      params << ['Port', n.port]
      params << ['CertFile', n.cert_file] unless n.cert_file.nil?
      params << ['CertKeyFile', n.cert_key_file] unless n.cert_key_file.nil?
      params << ['KeyPass', n.key_pass] unless n.key_pass.nil?
      params << ['CAFile', n.ca_file] unless n.ca_file.nil?
      params << ['CADir', n.ca_dir] unless n.ca_dir.nil?
      params << ['CRLFile', n.crl_file] unless n.crl_file.nil?
      params << ['CRLDir', n.crl_dir] unless n.crl_dir.nil?

      params << ['AllowUntrusted',
                 n.allow_untrusted.to_s.upcase] unless n.allow_untrusted.nil?

    when 'om_tcp', 'om_udp'
      params << ['Host', n.host]
      params << ['Port', n.port]
      params << ['SockBufSize', n.sock_buf_size] unless n.sock_buf_size.nil?

    when 'om_uds'
      params << ['uds', n.uds]

    else
      fail 'Tried to write nxlog config for unrecognised output module: ' +
        n.output_module

    end

    # create template with above parameters
    template config_filename(n.name) do
      cookbook 'nxlog'
      source 'resources/destination.conf.erb'
      variables name: n.name, params: params
      notifies :restart, 'service[nxlog]', :delayed
    end

    # create default definition file if this is a default destination
    template default_filename(n.name) do
      cookbook 'nxlog'
      source 'resources/destination.default.erb'
      variables name: n.name
      notifies :restart, 'service[nxlog]', :delayed
      only_if { n.default }
    end
  end
end

action :delete do
  converge_by("Delete #{new_resource}") do
    n = new_resource

    template config_filename(new_resource.name) do
      cookbook 'nxlog'
      source 'resources/destination.conf.erb'
      action :delete
      notifies :restart, 'service[nxlog]', :delayed
    end

    template default_filename(n.name) do
      cookbook 'nxlog'
      source 'resources/destination.default.erb'
      action :delete
      notifies :restart, 'service[nxlog]', :delayed
      only_if { n.default }
    end
  end
end
