#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

$plugin_name = 'fuel-plugin-rally'

$rally_hash = hiera_hash($plugin_name, undef)

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

$access_hash = hiera_hash('access', undef)
$username = $access_hash['user']
$password = $access_hash['password']
$tenant_name = $access_hash['tenant']

class { 'rally':
  repository_url  => $repository_url,
  repository_tag  => $repository_tag,
  auth_url        => $auth_url,
  public_hostname => $public_hostname,
  public_vip      => $public_vip,
  username        => $username,
  password        => $password,
  tenant_name     => $tenant_name,
}
