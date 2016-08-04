class rally::install inherits rally {

  $rally_installer = '/tmp/install_rally.sh'

  $cmd = "${rally_installer} \
    --yes \
    --no-color \
    --target ${rally::rally_venv} \
    --url ${rally::repository_url} \
    --branch ${rally::repository_tag}"

  file { "${rally_installer}":
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/rally/install_rally.sh',
    before => Exec[$rally_installer],
  }

  $packages = {
    'libssl-dev'   => {},
    'libffi-dev'   => {},
    'python-dev'   => {},
    'libxml2-dev'  => {},
    'libxslt1-dev' => {},
    'libpq-dev'    => {},
    'git'          => {},
    'python-pip'   => {},
  }
  $defaults = {
    ensure => installed,
    before => Exec[$rally_installer],
  }
  create_resources(package, $packages, $defaults)

  if $rally::create_user == true and $rally::rally_user != 'root' {
    user { "${rally::rally_user}":
      ensure     => present,
      managehome => true,
      home       => $rally::rally_home,
      shell      => '/bin/bash',
      before     => Exec[$rally_installer],
    }
  }

  exec { "${rally_installer}":
    command => $cmd,
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    user    => $rally::rally_user,
    cwd     => $rally::rally_home,
    timeout => 600,
    unless  => "test -x ${rally::rally_venv}/bin/rally",
  }
}
