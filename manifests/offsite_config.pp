class zpr::offsite_config (
  $home                = $zpr::params::home,
  $user                = $zpr::params::user,
  $offsite_config_file = $zpr::params::offsite_config_file,
  $aws_access_key      = $zpr::params::aws_access_key,
  $aws_secret_key      = $zpr::params::aws_secret_key,
  $gpg_passphrase      = $zpr::params::gpg_passphrase,
) inherits zpr::params {
  file { "${home}/${offsite_config_file}":
    ensure  => file,
    owner   => $user,
    mode    => '0400',
    content => template('zpr/offsite_config.erb')
  }
}
