file { '/tmp/hello-file':
    ensure  => 'present',
    replace => 'no', # this is the important property
    content => "From Puppet\n",
    mode    => '0644',
  }