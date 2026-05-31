# frozen_string_literal: true

provides :nxlog_syslog
unified_mode true
include ScNxLog::Helpers

use '_partial/_config'

property :logger_disable, String, default: 'rsyslog'
property :destinations, [String, Array], default: ScNxLog::DEFAULTS_KEY
property :socket_path, String, default: '/var/run/nxlog/devlog'

action_class do
  include ScNxLog::Helpers
end

action :create do
  raise 'nxlog_syslog is not supported on Windows' if platform_family?('windows')

  service new_resource.logger_disable do
    action %i(disable stop)
    not_if { new_resource.logger_disable.empty? }
  end

  file '/dev/log' do
    action :delete
    not_if { ::File.symlink?('/dev/log') }
  end

  directory ::File.dirname(new_resource.socket_path) do
    recursive true
    action :create
  end

  link '/dev/log' do
    to new_resource.socket_path
    action :create
  end

  nxlog_source 'syslog' do
    conf_dir new_resource.conf_dir
    restart_service new_resource.restart_service
    input_module 'im_uds'
    uds new_resource.socket_path
    exec 'parse_syslog_bsd();'
    flow_control false
    destination Array(new_resource.destinations)
    action :create
  end
end

action :delete do
  nxlog_source 'syslog' do
    conf_dir new_resource.conf_dir
    restart_service new_resource.restart_service
    input_module 'im_uds'
    uds new_resource.socket_path
    action :delete
  end

  link '/dev/log' do
    action :delete
    only_if { ::File.symlink?('/dev/log') && ::File.readlink('/dev/log') == new_resource.socket_path }
  end
end
