# frozen_string_literal: true

nxlog_install 'default' do
  install_package false
  manage_service false
end

nxlog_destination 'test' do
  restart_service false
  file '/var/log/nxlog/test.log'
end

nxlog_destination 'test_2' do
  restart_service false
  file '/var/log/nxlog/test2.log'
  default true
end

nxlog_source 'mark' do
  restart_service false
  input_module 'im_mark'
  mark '-> -> MARK <- <-'
  mark_interval 1
  destination ['test', ScNxLog::DEFAULTS_KEY]
end
