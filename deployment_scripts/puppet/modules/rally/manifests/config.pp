class rally::config inherits rally {

  $rally_config = '/etc/rally/deployment/existing.json'
  $rally_deployment = 'existing'

  host { "${rally::public_hostname}":
    ensure => present,
    ip     => $rally::public_vip,
  }

  file { 'deployment':
    ensure  => directory,
    path    => '/etc/rally/deployment'
  } ->
  file { "${rally_config}":
    ensure  => file,
    content => template('rally/existing.json.erb'),
    mode    => '0644',
  }

  $cmd = "/usr/local/bin/rally deployment create \
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
    ],
    require => File[$rally_config],
    unless  => "/usr/local/bin/rally deployment show \
      --deployment ${rally_deployment}",
  }
}
