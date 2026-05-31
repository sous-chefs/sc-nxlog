# frozen_string_literal: true

provides :nxlog_destination
unified_mode true
include ScNxLog::Helpers

use '_partial/_config'

property :output_module, String,
         equal_to: %w(om_blocker om_dbi om_exec om_file om_http om_null om_ssl om_tcp om_udp om_uds),
         default: 'om_file'
property :exec, String
property :output_type, String, equal_to: %w(LineBased Dgram Binary)
property :default, [true, false], default: false
property :driver, String
property :sql, String
property :options, Array
property :command, String
property :args, Array
property :file, String
property :create_dir, [true, false]
property :truncate, [true, false]
property :sync, [true, false]
property :url, String
property :content_type, String
property :https_cert_file, String
property :https_cert_key_file, String
property :https_key_pass, String
property :https_ca_file, String
property :https_ca_dir, String
property :https_crl_file, String
property :https_crl_dir, String
property :https_allow_untrusted, [true, false]
property :host, String
property :port, Integer
property :cert_file, String
property :cert_key_file, String
property :key_pass, String
property :ca_file, String
property :ca_dir, String
property :crl_file, String
property :crl_dir, String
property :allow_untrusted, [true, false]
property :sock_buf_size, Integer
property :uds, String, default: '/dev/log'

action_class do
  include ScNxLog::Helpers

  def config_filename
    "#{new_resource.conf_dir}/nxlog.conf.d/10_op_#{new_resource.name}.conf"
  end

  def default_filename
    "#{new_resource.conf_dir}/nxlog.conf.d/op_#{new_resource.name}.default"
  end

  def quoted_file(path)
    path =~ /["']/ ? path : "\"#{path}\""
  end

  def destination_params
    params = []
    params << ['Module', new_resource.output_module]
    params << ['Exec', new_resource.exec] if new_resource.exec
    params << ['OutputType', new_resource.output_type] if new_resource.output_type

    case new_resource.output_module
    when 'om_dbi'
      params << ['Driver', new_resource.driver]
      params << ['SQL', new_resource.sql]
      Array(new_resource.options).each { |option| params << ['Option', option] }
    when 'om_exec'
      params << ['Command', new_resource.command]
      Array(new_resource.args).each { |arg| params << ['Arg', arg] }
    when 'om_file'
      params << ['CreateDir', new_resource.create_dir] unless new_resource.create_dir.nil?
      params << ['Truncate', new_resource.truncate] unless new_resource.truncate.nil?
      params << ['Sync', new_resource.sync] unless new_resource.sync.nil?
      params << ['File', quoted_file(new_resource.file)]
    when 'om_http'
      params << ['Url', new_resource.url]
      params << ['ContentType', new_resource.content_type] if new_resource.content_type
      params << ['HTTPSCertFile', new_resource.https_cert_file] if new_resource.https_cert_file
      params << ['HTTPSCertKeyFile', new_resource.https_cert_key_file] if new_resource.https_cert_key_file
      params << ['HTTPSKeyPass', new_resource.https_key_pass] if new_resource.https_key_pass
      params << ['HTTPSCAFile', new_resource.https_ca_file] if new_resource.https_ca_file
      params << ['HTTPSCADir', new_resource.https_ca_dir] if new_resource.https_ca_dir
      params << ['HTTPSCRLFile', new_resource.https_crl_file] if new_resource.https_crl_file
      params << ['HTTPSCRLDir', new_resource.https_crl_dir] if new_resource.https_crl_dir
      params << ['HTTPSAllowUntrusted', new_resource.https_allow_untrusted.to_s.upcase] unless new_resource.https_allow_untrusted.nil?
    when 'om_ssl'
      params << ['Host', new_resource.host]
      params << ['Port', new_resource.port]
      params << ['CertFile', new_resource.cert_file] if new_resource.cert_file
      params << ['CertKeyFile', new_resource.cert_key_file] if new_resource.cert_key_file
      params << ['KeyPass', new_resource.key_pass] if new_resource.key_pass
      params << ['CAFile', new_resource.ca_file] if new_resource.ca_file
      params << ['CADir', new_resource.ca_dir] if new_resource.ca_dir
      params << ['CRLFile', new_resource.crl_file] if new_resource.crl_file
      params << ['CRLDir', new_resource.crl_dir] if new_resource.crl_dir
      params << ['AllowUntrusted', new_resource.allow_untrusted.to_s.upcase] unless new_resource.allow_untrusted.nil?
    when 'om_tcp', 'om_udp'
      params << ['Host', new_resource.host]
      params << ['Port', new_resource.port]
      params << ['SockBufSize', new_resource.sock_buf_size] unless new_resource.sock_buf_size.nil?
    when 'om_uds'
      params << ['UDS', new_resource.uds]
    when 'om_blocker', 'om_null'
      nil
    else
      raise "Unrecognized NXLog output module: #{new_resource.output_module}"
    end

    params
  end
end

action :create do
  service 'nxlog' do
    supports status: true, restart: true
    action :nothing
    only_if { new_resource.restart_service }
  end

  directory "#{new_resource.conf_dir}/nxlog.conf.d" do
    recursive true
    action :create
  end

  template config_filename do
    cookbook 'sc-nxlog'
    source 'resources/destination.conf.erb'
    variables name: new_resource.name, params: destination_params
    action :create
    notifies :restart, 'service[nxlog]', :delayed if new_resource.restart_service
  end

  template default_filename do
    cookbook 'sc-nxlog'
    source 'resources/destination.default.erb'
    variables name: new_resource.name
    action new_resource.default ? :create : :delete
    notifies :restart, 'service[nxlog]', :delayed if new_resource.restart_service
  end
end

action :delete do
  file config_filename do
    action :delete
  end

  file default_filename do
    action :delete
  end
end
