class rally::config inherits rally {

  $rally_config = "/etc/rally/deployment/existing.json"
  $rally_deployment = 'existing'

  $rally_hostname = hiera("rally::public_hostname")
  $rally_vip = hiera("rally::public_vip")

  $fuel_version = hiera("fuel_version")

  host { "${rally_hostname}":
    ensure => present,
    ip     => $rally_vip,
  }

  file {"deployment":
    ensure  => directory,
    path    => "/etc/rally/deployment"
  } ->
  file { "${rally_config}":
    ensure  => file,
    content => template('rally/existing.json.erb'),
    owner   => $rally::rally_user,
    group   => $rally::rally_group,
    mode    => '0644',
  }

  $cmd = "/usr/local/bin/rally deployment create \
    --file=${rally_config} \
    --name ${rally_deployment}"

  exec { "dependencies_upgrade":
    command => "pip install --upgrade 'python-keystoneclient>=2.0.0'",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    before  => Exec["register_deployment"],
    onlyif  => 'test "$fuel_version" = "8.0"',
  }

  exec { 'register_deployment':
    command => $cmd,
    path    => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin',
      '/usr/local/bin',
    ],
    user    => $rally::rally_user,
    cwd     => $rally::rally_home,
    require => File[$rally_config],
    unless  => "/usr/local/bin/rally deployment show \
      --deployment ${rally_deployment}",
  }
}