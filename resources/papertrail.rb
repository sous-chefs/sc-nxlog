# frozen_string_literal: true

provides :nxlog_papertrail
unified_mode true
include ScNxLog::Helpers

use '_partial/_config'

property :port, Integer, required: true
property :host, String, default: 'logs'
property :default, [true, false], default: false

action :create do
  nxlog_destination new_resource.name do
    conf_dir new_resource.conf_dir
    restart_service new_resource.restart_service
    output_module 'om_ssl'
    host "#{new_resource.host}.papertrailapp.com"
    port new_resource.port
    ca_file ::File.join(new_resource.conf_dir, 'certs', 'papertrail-bundle.pem')
    allow_untrusted false
    exec '$Hostname = hostname(); to_syslog_ietf();'
    default new_resource.default
    action :create
  end
end

action :delete do
  nxlog_destination new_resource.name do
    conf_dir new_resource.conf_dir
    restart_service new_resource.restart_service
    output_module 'om_ssl'
    host "#{new_resource.host}.papertrailapp.com"
    port new_resource.port
    ca_file ::File.join(new_resource.conf_dir, 'certs', 'papertrail-bundle.pem')
    allow_untrusted false
    default new_resource.default
    action :delete
  end
end
