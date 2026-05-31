# frozen_string_literal: true

nxlog_install 'default' do
  install_package false
  manage_service false
end

file '/tmp/papertrail-bundle.pem' do
  content "test certificate\n"
  action :create
end

nxlog_papertrail_bundle 'default' do
  restart_service false
  source 'file:///tmp/papertrail-bundle.pem'
end

nxlog_papertrail 'papertrail' do
  restart_service false
  host 'logs2'
  port 17_992
  default true
end
