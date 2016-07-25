class zpr::duplicity_runner (
  $passfile            = "${zpr::params::home}/${zpr::params::key_name}.gpg",
  $user                = $zpr::params::user,
  $home                = $zpr::params::home,
  $gpg_key_id          = $zpr::params::gpg_key_id,
  $signing_key         = $zpr::params::gpg_key_id,
  $offsite_config_file = $zpr::params::offsite_config_file,
) inherits zpr::params {
  file { "${home}/run_duplicity":
    ensure  => file,
    owner   => $user,
    mode    => '0500',
    content => template('zpr/run_duplicity.erb')
  }
}
