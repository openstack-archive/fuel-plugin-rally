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
