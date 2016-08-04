class rally::install (
  $repository_url = 'https://github.com/openstack/rally',
  $repository_tag = 'master',
) {

  $rally_installer = '/tmp/install_rally.sh'

  $cmd = "${rally_installer} \
    --yes \
    --system \
    --no-color \
    --url ${repository_url} \
    --branch ${repository_tag}"

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

  exec { "${rally_installer}":
    command => $cmd,
    path    => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin',
      '/usr/local/bin',
      '/usr/local/sbin',
    ],
    timeout => 600,
    unless  => "rally --version",
  }
}
