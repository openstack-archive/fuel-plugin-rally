class rally::install inherits rally {

  $rally_installer = '/tmp/install_rally.sh'
  $rally_requirements = '/tmp/rally_requirements.txt'

  $cmd = "${rally_installer} \
    --yes \
    --no-color \
    --system \
    --url ${rally::repository_url} \
    --branch ${rally::repository_tag}"

  file { "${rally_installer}":
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/rally/install_rally.sh',
    before => Exec[$rally_installer],
  }

  file { "${rally_requirements}":
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/rally/requirements.txt',
    before => Exec["update_requirements"],
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

  exec {"update_requirements":
    command => "cat $rally_requirements | xargs pip install",
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
    timeout => 500,
  }

  exec { "${rally_installer}":
    command => $cmd,
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
    timeout => 500,
    require => Exec["update_requirements"],
    unless  => "test -x /usr/local/bin/rally",
  }
}
