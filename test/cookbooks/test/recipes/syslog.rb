# frozen_string_literal: true

nxlog_install 'default' do
  install_package false
  manage_service false
end

nxlog_destination 'test' do
  restart_service false
  file '/tmp/test.log'
end

nxlog_syslog 'default' do
  restart_service false
  logger_disable ''
  destinations ['test']
end
