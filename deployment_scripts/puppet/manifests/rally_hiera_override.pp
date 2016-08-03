# Copyright 2016 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

notice('fuel-plugin-rally: rally_hiera_override.pp')

# maybe fo future use
$network_scheme   = hiera_hash('network_scheme')
$network_metadata = hiera_hash('network_metadata')
prepare_network_config($network_scheme)

$rally = hiera_hash('fuel-plugin-rally', undef)

if ($rally['repository_type'] == 'default')  {
  $repository_url = 'https://github.com/openstack/rally'
  $repository_tag = $rally['repository_tag']
} else {
  $repository_url = $rally['repository_custom']
  $repository_tag = $rally['repository_custom_tag']
}

$management_ip = get_network_role_property('management', 'ipaddr')

$hiera_dir = '/etc/hiera/override'
$plugin_name = 'rally'
$plugin_yaml = "${plugin_name}.yaml"

$calculated_content = inline_template('
---
rally::listen_address: <%= @management_ip %>
rally::repository_url: <%= @repository_url %>
rally::repository_tag: <%= @repository_tag %>
')

###################
file {'/etc/hiera/override':
  ensure  => directory,
} ->
file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => "${calculated_content}\n",
}
