#
# Cookbook Name:: collectd
# Recipe:: client
#
# Copyright 2010, Atari, Inc
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

include_recipe "collectd"

# On Chef Solo, we use the node['collectd']['server'] attribute, and on
# normal Chef, we leverage the search query.
if Chef::Config[:solo]
  if node['collectd']['server']
    collectd_servers = Array(node['collectd']['server'])
  else
    Chef::Application.fatal!("Chef Solo does not support search. You must set node['collectd']['server']!")
  end
else
  results = search(:node, node['collectd']['server_search']).map { |n| n['ipaddress'] }
  collectd_servers = Array(node['collectd']['server']) + Array(results)
end

if collectd_servers.empty?
  Chef::Application.fatal!('The collectd::client recipe was unable to determine the remote collectd server. Checked both the server attribute and search!')
end

collectd_plugin "network" do
  options :server=>collectd_servers
end
