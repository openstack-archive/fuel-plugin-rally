class rally (
  $repository_url = $rally::params::repository_url,
  $repository_tag = $rally::params::repository_tag,
  $create_user    = $rally::params::create_user,
  $rally_user     = $rally::params::rally_user,
  $auth_url       = $rally::params::auth_url,
  $username       = $rally::params::usermame,
  $password       = $rally::params::password,
  $tenant_name    = $rally::params::tenant_name,
) inherits rally::params {

  $rally_group = $rally_user
  $rally_home = $rally_user ? {
    'root'  => '/root',
    default => "/home/${rally_user}",
  }
  $rally_venv = "${rally_home}/rally"

  anchor { 'rally::begin': } ->
  class { 'rally::install': } ->
  class { 'rally::config': } ->
  anchor { 'rally::end': }
}
