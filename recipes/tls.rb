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

package 'rsyslog-gnutls' do
  action :install
end

cert_path = node['loggly']['tls']['cert_path']

directory cert_path do
  owner 'root'
  group 'syslog'
  mode 0750
  action :create
  recursive true
end

loggly_crt_path = "#{Chef::Config['file_cache_path']}/loggly.com.crt"
sf_bundle_path = "#{Chef::Config['file_cache_path']}/sf_bundle.crt"

remote_file 'download loggly.com cert' do
  owner 'root'
  group 'root'
  mode 0644
  path loggly_crt_path
  source node['loggly']['tls']['cert_url']
  checksum node['loggly']['tls']['cert_checksum']
end

remote_file 'download intermediate cert' do
  owner 'root'
  group 'root'
  mode 0644
  path sf_bundle_path
  source node['loggly']['tls']['intermediate_cert_url']
  checksum node['loggly']['tls']['intermediate_cert_checksum']
end

bash 'bundle certificate' do
  user 'root'
  cwd cert_path
  code <<-EOH
    cat {#{sf_bundle_path},#{loggly_crt_path}} > loggly_full.crt
  EOH
  not_if { ::File.exists?("#{node['loggly']['tls']['cert_path']}/loggly_full.crt") }
end
