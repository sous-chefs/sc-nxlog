# frozen_string_literal: true

provides :nxlog_papertrail_bundle
unified_mode true
include ScNxLog::Helpers

use '_partial/_config'

property :source, String, default: 'https://papertrailapp.com/tools/papertrail-bundle.pem'

action_class do
  include ScNxLog::Helpers
end

action :create do
  service 'nxlog' do
    supports status: true, restart: true
    action :nothing
    only_if { new_resource.restart_service }
  end

  directory ::File.join(new_resource.conf_dir, 'certs') do
    recursive true
    action :create
  end

  remote_file ::File.join(new_resource.conf_dir, 'certs', 'papertrail-bundle.pem') do
    source new_resource.source
    action :create
    notifies :restart, 'service[nxlog]', :delayed if new_resource.restart_service
  end
end

action :delete do
  file ::File.join(new_resource.conf_dir, 'certs', 'papertrail-bundle.pem') do
    action :delete
  end
end
