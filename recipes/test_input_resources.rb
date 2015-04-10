#
# Cookbook Name:: nxlog_ce
# Recipe:: default
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

include_recipe 'nxlog_ce::default'

nxlog_ce_source 'test_im_file' do
  file '/var/log/test.log'
  poll_interval 5.5
  close_when_idle false
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_exec' do
  input_module 'im_exec'
  command '/sbin/log_processor'
  args %w(foo bar baz)
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_internal' do
  input_module 'im_internal'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_kernel' do
  input_module 'im_kernel'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_mark' do
  input_module 'im_mark'
  mark 'marky mark'
  mark_interval 20
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_mseventlog' do
  input_module 'im_mseventlog'
  utf8 true
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_msvistalog' do
  input_module 'im_msvistalog'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_null' do
  input_module 'im_null'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_ssl' do
  input_module 'im_ssl'
  host 'log.example.org'
  port 666
  cert_file '%CERTDIR%/client-cert.pem'
  cert_key_file '%CERTDIR%/client-key.pem'
  ca_file '%CERTDIR%/ca.pem'
  allow_untrusted false
  input_type 'Binary'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_tcp' do
  input_module 'im_tcp'
  host 'log.example.org'
  port 667
  input_type 'Binary'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_udp' do
  input_module 'im_udp'
  host 'log.example.org'
  port 666
  input_type 'Binary'
  destination 'test_om_udp'
end

nxlog_ce_source 'test_im_uds' do
  input_module 'im_uds'
  uds '/dev/log'
  destination 'test_om_udp'
end
