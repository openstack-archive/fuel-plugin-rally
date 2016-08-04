class rally::config inherits rally {

  $rally_config = "${rally::rally_home}/existing.json"
  $rally_deployment = 'existing'

  file { "${rally_config}":
    ensure  => file,
    content => template('rally/existing.json.erb'),
    owner   => $rally::rally_user,
    group   => $rally::rally_group,
    mode    => '0644',
  }

  $cmd = "${rally::rally_venv}/bin/rally deployment create \
    --file=${rally_config} \
    --name ${rally_deployment}"

  exec { 'register_deployment':
    command => $cmd,
    path    => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin',
      "${rally::rally_venv}/bin",
    ],
    user    => $rally::rally_user,
    cwd     => $rally::rally_home,
    require => File[$rally_config],
    unless  => "${rally::rally_venv}/bin/rally deployment show \
      --deployment ${rally_deployment}",
  }
}
