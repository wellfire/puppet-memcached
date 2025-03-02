class memcached(
  $package_ensure  = 'present',
  $logfile         = '/var/log/memcached.log',
  $max_memory      = false,
  $listen_ip       = '0.0.0.0',
  $tcp_port        = '11211',
  $udp_port        = '11211',
  $user            = 'nobody',
  $max_connections = '8192'
) {

  include memcached::params

  package { $memcached::params::package_name:
    ensure => $package_ensure,
  }

  file { $memcached::params::config_file:
    owner   => root,
    group   => root,
    content => template("${module_name}/memcached.conf.erb"),
    require => Package[$memcached::params::package_name],
  }

  service { $memcached::params::service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    subscribe  => File[$memcached::params::config_file],
  }
}
