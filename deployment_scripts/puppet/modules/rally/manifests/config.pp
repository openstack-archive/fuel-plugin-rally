class rally::config (
  $auth_url    = undef,
  $username    = undef,
  $password    = undef,
  $tenant_name = undef,
) {

  $rally_config = '/root/existing.json'
  $rally_deployment = 'existing'

  file { "${rally_config}":
    ensure  => file,
    content => template('rally/existing.json.erb'),
  }

  $cmd = "rally deployment create \
    --file=${rally_config} \
    --name ${rally_deployment}"

  exec { 'register_deployment':
    command => $cmd,
    path    => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin',
      '/usr/local/bin',
      '/usr/local/sbin',
    ],
    require => File[$rally_config],
    unless  => "rally deployment show --deployment ${rally_deployment}",
  }
}
