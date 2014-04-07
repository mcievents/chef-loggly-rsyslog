#
# Cookbook Name:: loggly-rsyslog
# Recipe:: default
#
# Copyright (C) 2014 Wyndham Jade LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'

service 'rsyslog'

loggly_token = Chef::EncryptedDataBagItem.load('loggly', 'token')['token']
raise "No loggly token was found in node attributes or data bag." if loggly_token.nil?

include_recipe "loggly-rsyslog::tls" if node['loggly']['tls']['enabled']

template '/etc/rsyslog.d/10-loggly.conf' do
  source 'loggly.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables({
    :monitor_files => !node['loggly']['log_files'].empty?,
    :tags => node['loggly']['tags'].nil? || node['loggly']['tags'].empty? ? '' : "tag=\\\"#{node['loggly']['tags'].join("\\\" tag=\\\"")}\\\"",
    :token => loggly_token
  })
  notifies :restart, "service[rsyslog]", :immediate
end
