#
# Cookbook Name:: nxlog
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

include_recipe 'nxlog::default'

nxlog_destination 'test_om_file' do
  file '/var/log/test.log'
end

nxlog_destination 'test_om_blocker' do
  output_module 'om_blocker'
end

nxlog_destination 'test_om_dbi' do
  output_module 'om_dbi'
  driver 'mysql'
  sql 'INSERT INTO log VALUES ($SyslogFacility, $SyslogSeverity, $Message)'
  options ['host 127.0.0.1', 'username foo', 'password bar', 'dbname nxlog']
end

nxlog_destination 'test_om_exec' do
  output_module 'om_exec'
  command '/usr/bin/foo'
  args %w(bar baz)
end

nxlog_destination 'test_om_https' do
  output_module 'om_http'
  url 'https://example.org/foo'
  https_cert_file '%CERTDIR%/client-cert.pem'
  https_cert_key_file '%CERTDIR%/client-key.pem'
  https_ca_file '%CERTDIR%/ca.pem'
  https_allow_untrusted false
end

nxlog_destination 'test_om_http' do
  output_module 'om_http'
  url 'http://example.org/bar'
end

nxlog_destination 'test_om_null' do
  output_module 'om_null'
end

nxlog_destination 'test_om_ssl' do
  output_module 'om_ssl'
  port 1234
  host 'foo.example.org'
  cert_file '%CERTDIR%/client-cert.pem'
  cert_key_file '%CERTDIR%/client-key.pem'
  ca_file '%CERTDIR%/ca.pem'
  allow_untrusted false
  output_type 'Binary'
end

nxlog_destination 'test_om_tcp' do
  output_module 'om_tcp'
  port 1234
  host 'foo.example.org'
end

nxlog_destination 'test_om_udp' do
  output_module 'om_udp'
  port 1234
  host 'foo.example.org'
end

nxlog_destination 'test_om_uds' do
  output_module 'om_uds'
  exec 'parse_syslog_bsd(); to_syslog_bsd();'
  uds '/dev/log'
end
