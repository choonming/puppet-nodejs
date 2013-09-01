class nodejs ($version, $arch='x64') {

  package { 'python':
    ensure  => present,
  }

  package { 'g++':
    ensure  => present,
  }

  package { 'make':
    ensure  => present,
  }

  exec { 'download nodejs tarball':
    command => "wget http://nodejs.org/dist/${version}/node-${version}-linux-${arch}.tar.gz",
    cwd     => '/opt',
    creates => "/opt/node-${version}-linux-${arch}.tar.gz",
    require => Package[ ['python', 'g++', 'make'] ],
    notify  => Exec['build nodejs'],
  }

  file { '/opt/build_nodejs.sh':
    ensure  => present,
    source  => 'puppet:///modules/nodejs/build_nodejs.sh',
    mode    => '0755',
    require => Exec['download nodejs tarball'],
  }

  exec { 'build nodejs':
    command => '/opt/build_nodejs.sh &',
    cwd     => '/opt',
    creates => '/usr/local/bin/node',
    path    => '/usr/bin:/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
    require => File['/opt/build_nodejs.sh'],
  }

}
