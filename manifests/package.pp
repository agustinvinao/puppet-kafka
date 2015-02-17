class kafka::package(
  $ensure  = undef,
  $version = undef,

  $package = undef,

  $configdir = undef,
  $logdir    = undef,
) {
  $real_ensure = $ensure ? {
    present => $version,
    default => absent
  }

  package { $package:
    ensure => $real_ensure,
  }

  if $::operatingsystem == 'Darwin' {
    include boxen::config

    $rendered_formula = '/tmp/boxen_kafka_formula.rb'

    file { $rendered_formula:
      ensure  => $ensure,
      content => template('kafka/darwin/formula.rb.erb')
    }

    ~>
    homebrew::formula { 'kafka':
      source => $rendered_formula
    }

    ->
    Package[$package]
  }


}
