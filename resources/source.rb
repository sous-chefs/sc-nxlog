# frozen_string_literal: true

provides :nxlog_source
unified_mode true
include ScNxLog::Helpers

use '_partial/_config'

property :input_module, String,
         equal_to: %w(im_exec im_file im_internal im_kernel im_mark im_mseventlog im_msvistalog im_null im_ssl im_tcp im_udp im_uds),
         required: true
property :destination, [String, Array], default: ScNxLog::DEFAULTS_KEY
property :input_type, String
property :exec, String
property :flow_control, [true, false]
property :save_pos, [true, false]
property :read_from_last, [true, false]
property :command, String
property :args, Array
property :restart, [true, false]
property :file, String
property :recursive, [true, false]
property :rename_check, [true, false]
property :close_when_idle, [true, false]
property :poll_interval, Float
property :dir_check_interval, Float
property :active_files, Integer
property :mark, String
property :mark_interval, Integer
property :sources, Array
property :utf8, [true, false]
property :query, String
property :channel, String
property :host, String, default: 'localhost'
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
    "#{new_resource.conf_dir}/nxlog.conf.d/20_ip_#{new_resource.name}.conf"
  end

  def quoted_file(path)
    path =~ /["']/ ? path : "\"#{path}\""
  end

  def source_params
    params = []
    params << ['Module', new_resource.input_module]
    params << ['Exec', new_resource.exec] if new_resource.exec
    params << ['InputType', new_resource.input_type] if new_resource.input_type
    params << ['FlowControl', new_resource.flow_control.to_s.upcase] unless new_resource.flow_control.nil?

    case new_resource.input_module
    when 'im_exec'
      params << ['Command', new_resource.command]
      Array(new_resource.args).each { |arg| params << ['Arg', arg] }
      params << ['Restart', new_resource.restart] unless new_resource.restart.nil?
    when 'im_file'
      params << ['SavePos', new_resource.save_pos] unless new_resource.save_pos.nil?
      params << ['ReadFromLast', new_resource.read_from_last] unless new_resource.read_from_last.nil?
      params << ['Recursive', new_resource.recursive] unless new_resource.recursive.nil?
      params << ['RenameCheck', new_resource.rename_check] unless new_resource.rename_check.nil?
      params << ['CloseWhenIdle', new_resource.close_when_idle] unless new_resource.close_when_idle.nil?
      params << ['PollInterval', new_resource.poll_interval] unless new_resource.poll_interval.nil?
      params << ['DirCheckInterval', new_resource.dir_check_interval] unless new_resource.dir_check_interval.nil?
      params << ['ActiveFiles', new_resource.active_files] unless new_resource.active_files.nil?
      params << ['File', quoted_file(new_resource.file)]
    when 'im_mark'
      params << ['Mark', new_resource.mark] unless new_resource.mark.nil?
      params << ['MarkInterval', new_resource.mark_interval] unless new_resource.mark_interval.nil?
    when 'im_mseventlog'
      params << ['Sources', new_resource.sources.join(',')] unless new_resource.sources.nil?
      params << ['UTF8', new_resource.utf8.to_s.upcase] unless new_resource.utf8.nil?
    when 'im_msvistalog'
      params << ['Query', new_resource.query] unless new_resource.query.nil?
      params << ['Channel', new_resource.channel] unless new_resource.channel.nil?
      params << ['PollInterval', new_resource.poll_interval] unless new_resource.poll_interval.nil?
    when 'im_ssl'
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
    when 'im_tcp', 'im_udp'
      params << ['Host', new_resource.host]
      params << ['Port', new_resource.port]
      params << ['SockBufSize', new_resource.sock_buf_size] unless new_resource.sock_buf_size.nil?
    when 'im_uds'
      params << ['UDS', new_resource.uds]
    when 'im_internal', 'im_kernel', 'im_null'
      nil
    else
      raise "Unrecognized NXLog input module: #{new_resource.input_module}"
    end

    params
  end

  def route_destinations
    Array(new_resource.destination).map do |destination|
      destination == ScNxLog::DEFAULTS_KEY ? '%DEFAULT_OUTPUTS%' : destination
    end
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
    source 'resources/source.conf.erb'
    variables(
      conf_dir: new_resource.conf_dir,
      destinations: route_destinations,
      include_glob: config_include_glob,
      name: new_resource.name,
      params: source_params
    )
    action :create
    notifies :restart, 'service[nxlog]', :delayed if new_resource.restart_service
  end
end

action :delete do
  file config_filename do
    action :delete
  end
end
