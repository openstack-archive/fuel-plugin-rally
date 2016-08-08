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

$plugin_name = 'fuel-plugin-rally'

$rally_hash = hiera_hash('fuel-plugin-rally', undef)

if $rally_hash {

  if ($rally_hash['repository_type'] == 'default')  {
    $repository_url = 'https://github.com/openstack/rally'
    $repository_tag = $rally_hash['repository_tag']
  } else {
    $repository_url = $rally_hash['repository_custom']
    $repository_tag = $rally_hash['repository_custom_tag']
  }

  $public_ssl = hiera_hash('public_ssl', undef)
  $proto = $public_ssl['services'] ? {
    true    => 'https',
    default => 'http',
  }
  $public_hostname = $public_ssl['hostname']
  $public_vip = hiera('public_vip', undef)
  $auth_url = "${proto}://${public_vip}:5000/v2.0"

  $access_hash = hiera_hash('access_hash', undef)
  $username = $access_hash['user']
  $password = $access_hash['password']
  $tenant_name = $access_hash['tenant']

  $hiera_file = "/etc/hiera/plugins/${plugin_name}.yaml"

  $calculated_content = inline_template('
---
rally::repository_url: <%= @repository_url %>
rally::repository_tag: <%= @repository_tag %>
rally::auth_url: <%= @auth_url %>
rally::public_hostname: <%= @public_hostname %>
rally::public_vip: <%= @public_vip %>
rally::username: <%= @username %>
rally::password: <%= @password %>
rally::tenant_name: <%= @tenant_name %>
')

  file { "/etc/hiera/plugins":
    ensure => 'directory',
  } ->
  file { "${hiera_file}":
    ensure  => file,
    content => $calculated_content,
  }

  # hiera file changes between 7.0 and 8.0 so we need to handle the override the
  # different yaml formats via these exec hacks.  It should be noted that the
  # fuel hiera task will wipe out these this update to the hiera.yaml
  exec { "${plugin_name}_hiera_override_7.0":
    command => "sed -i '/  - override\\/plugins/a\\  - plugins\\/${plugin_name}' /etc/hiera.yaml",
    path    => '/bin:/usr/bin',
    unless  => "grep -q '^  - plugins/${plugin_name}' /etc/hiera.yaml",
    onlyif  => 'grep -q "^  - override/plugins" /etc/hiera.yaml'
  }

  exec { "${plugin_name}_hiera_override_8.0":
    command => "sed -i '/    - override\\/plugins/a\\    - plugins\\/${plugin_name}' /etc/hiera.yaml",
    path    => '/bin:/usr/bin',
    unless  => "grep -q '^    - plugins/${plugin_name}' /etc/hiera.yaml",
    onlyif  => 'grep -q "^    - override/plugins" /etc/hiera.yaml'
  }
}
