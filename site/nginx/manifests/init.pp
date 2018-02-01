class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
  $message  = 'Message from default params',
) inherits nginx::params {

  File {
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }
  
  notify { "------------- MESSAGE IS: ${message}": }

  file { $docroot:
    ensure => directory,
  }
  
  file { "${docroot}/index.html":
    ensure  => file,
    mode    => '0777',
    #source  => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp'),
    require => File[$docroot],
  }
  
  package { $package:
    ensure => present,
    before => File[$blockdir],
  }
  
  file { $blockdir:
    ensure => directory,
  } 
  
  file { "${confdir}/nginx.conf":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/nginx.conf',
    content => epp('nginx/nginx.conf.epp',
                      {
                         user     => $user,
                         logdir   => $logdir,
                         blockdir => $blockdir,
                         confdir  => $confdir,
                      }),
    require => Package[$package],
    #notify  => Service['nginx'],
  }
    
  file { "${blockdir}/default.conf":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/default.conf',
    content => epp('nginx/default.conf.epp', { docroot => $docroot, }),
    require => File[$blockdir],
    #notify  => Service['nginx'],
  }
  
  #service { $service:
  #  ensure    => running,
  #  enable    => true,
  #  require   => File["${docroot}/index.html"],
  #  subscribe => [File["${confdir}/nginx.conf"], File["${blockdir}/default.conf"]],
  #}
}