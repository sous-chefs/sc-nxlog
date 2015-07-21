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

def symbolize_attrs(obj)
  if obj.is_a? String
    obj =~ /^:/ ? obj.sub(/^:/, '').to_sym : obj
  elsif obj.is_a? Array
    obj.map { |v| symbolize_attrs(v) }
  elsif obj.is_a? Hash
    Hash[obj.map { |k, v| [k, symbolize_attrs(v)] }]
  else
    obj
  end
end

symbolize_attrs(node['nxlog']['sources'] || {}).each_pair do |name, values|
  nxlog_source name do
    values.each_pair do |key, value|
      public_send(key, value)
    end
  end
end

symbolize_attrs(node['nxlog']['destinations'] || {}).each_pair do |name, values|
  nxlog_destination name do
    values.each_pair do |key, value|
      public_send(key, value)
    end
  end
end

symbolize_attrs(node['nxlog']['papertrails'] || {}).each_pair do |name, values|
  nxlog_papertrail name do
    values.each_pair do |key, value|
      public_send(key, value)
    end
  end
end
