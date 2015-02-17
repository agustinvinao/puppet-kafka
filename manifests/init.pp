# Usage:
#
#     include kafka
class kafka (
  $ensure        = undef,
  $enable        = undef,

  $package        = undef,
  $version        = undef,

  $host          = undef,
  $port          = undef,

  $configdir     = undef,
  $datadir       = undef,
  $logdir        = undef,

  $broker_config = undef,
  $zookeeper     = undef,

  $executable    = undef,
  $servicename   = undef,

){
  validate_string(
    $ensure,
    $host,
    $port,
    $version,
    $servicename,
    $executable
  )

  validate_absolute_path(
    $configdir,
    $datadir,
    $logdir
  )

  validate_bool(
    $enable
  )

  class { 'kafka::config':
    ensure        => $ensure,

    configdir     => $configdir,
    datadir       => $datadir,
    logdir        => $logdir,

    host          => $host,
    port          => $port,

    executable    => $executable,
    broker_config => $broker_config,
    zookeeper     => $zookeeper,

    servicename   => $servicename,
    notify        => Service['kafka'],
  }

  ~>
  class { 'kafka::package':
    ensure  => $ensure,
    package => $package,
    version => $version,

    configdir => $configdir,
    logdir    => $logdir
  }

  ~>
  class { 'kafka::service':
    ensure      => $ensure,

    enable      => $enable,
    servicename => $servicename
  }
}
