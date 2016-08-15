# == Class: rally
#
# Install and configure a Rally node
#
# === Parameters
#
# See below for a complete list of parameters accepted.

class rally (
  $repository_url  = $rally::params::repository_url,
  $repository_tag  = $rally::params::repository_tag,
  $auth_url        = $rally::params::auth_url,
  $public_hostname = $rally::params::public_hostname,
  $public_vip      = $rally::params::public_vip,
  $username        = $rally::params::usermame,
  $password        = $rally::params::password,
  $tenant_name     = $rally::params::tenant_name,
) inherits rally::params {

  anchor { 'rally::begin': } ->
  class { 'rally::install': } ->
  class { 'rally::config': } ->
  anchor { 'rally::end': }
}
