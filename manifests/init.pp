class nodejs ($version) {

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
    command => "wget http://nodejs.org/dist/${version}/node-${version}.tar.gz",
    cwd     => '/opt',
    require => Package[ ['python', 'g++', 'make'] ],
  }

  file { '/opt/build_nodejs.sh':
    ensure  => present,
    source  => 'puppet:///modules/nodejs/build_nodejs.sh',
    mode    => '0755',
    require => Exec['download nodejs tarball'],
  }

  exec { 'build nodejs',
    command => '/opt/build_nodejs.sh &',
    cwd     => '/opt',
    path    => '/usr/bin:/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
    require => [ File['/opt/build_nodejs.sh'], Exec['download nodejs tarball'] ],
  }

}
