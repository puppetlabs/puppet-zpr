# A class to install task-spooler
class zpr::task_spooler (
  $ensure      = latest,
  $pkg_name    = $zpr::params::tsp_pkg_name,
  $home        = $zpr::params::home,
  $user        = $zpr::params::user,
  $slots       = $zpr::params::slots,
  $maxfinished = $zpr::params::maxfinished,
) inherits zpr::params {

  $tsp_options = [
    "export TS_SLOTS=${slots}",
    "export TS_MAXFINISHED=${maxfinished}"
  ]

  package { $pkg_name:
    ensure => $ensure
  }

  file_line { ". ${home}/.tsprc":
    ensure => present,
    line   => 'source .tsprc',
    path   => "${home}/.profile"
  }

  file { "${home}/.tsprc":
      ensure  => present,
      owner   => $user,
      group   => $user,
      mode    => '0500',
      content => join( $tsp_options, "\n" )
  }

  file { "${home}/check_slots":
    owner   => $user,
    group   => $user,
    mode    => '0500',
    content => join([
      '#!/usr/bin/env bash',
      '[[ $(tsp -S) -eq $1 ]]'
    ], "\n")
  }

  exec { 'set_slots':
    path    => '/bin:/usr/bin',
    command => "tsp -S ${slots}",
    unless  => "${home}/check_slots ${slots}",
    user    => $user
  }
}
