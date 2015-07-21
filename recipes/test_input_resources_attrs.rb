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

# creates the same resources as test_default_resources, but as node attributes

node.override['nxlog'] = JSON.parse(<<EOT)
{
  "sources": {
    "test_im_file": {
      "file": "/var/log/test.log",
      "poll_interval": 5.5,
      "close_when_idle": false,
      "destination": "test_om_udp"
    },
    "test_im_exec": {
      "input_module": "im_exec",
      "command": "/sbin/log_processor",
      "args": ["foo", "bar", "baz"],
      "destination": "test_om_udp"
    },
    "test_im_internal": {
      "input_module": "im_internal",
      "destination": "test_om_udp"
    },
    "test_im_kernel": {
      "input_module": "im_kernel",
      "destination": "test_om_udp"
    },
    "test_im_mark": {
      "input_module": "im_mark",
      "mark_interval": 20,
      "mark": "marky mark",
      "destination": "test_om_udp"
    },
    "test_im_mseventlog": {
      "input_module": "im_mseventlog",
      "utf8": true,
      "destination": "test_om_udp"
    },
    "test_im_msvistalog": {
      "input_module": "im_msvistalog",
      "destination": "test_om_udp"
    },
    "test_im_null": {
      "input_module": "im_null",
      "destination": "test_om_udp"
    },
    "test_im_ssl": {
      "input_module": "im_ssl",
      "host": "log.example.org",
      "port": 666,
      "cert_file": "%CERTDIR%/client-cert.pem",
      "cert_key_file": "%CERTDIR%/client-key.pem",
      "ca_file": "%CERTDIR%/ca.pem",
      "allow_untrusted": false,
      "input_type": "Binary",
      "destination": "test_om_udp"
    },
    "test_im_tcp": {
      "input_module": "im_tcp",
      "host": "log.example.org",
      "port": 667,
      "input_type": "Binary",
      "destination": "test_om_udp"
    },
    "test_im_udp": {
      "input_module": "im_udp",
      "host": "log.example.org",
      "port": 666,
      "input_type": "Binary",
      "destination": "test_om_udp"
    },
    "test_im_uds": {
      "input_module": "im_uds",
      "uds": "/dev/log",
      "destination": "test_om_udp"
    }
  }
}
EOT

include_recipe 'nxlog::default'
