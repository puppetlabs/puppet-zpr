# A class that creates ssh keys without passphrases
define zpr::generate_ssh_key (
  $home,
  $user       = $title,
  $group      = $user,
  $path       = '/usr/bin',
  $bits       = '4096',
  $gen        = true,
  $create_dir = true,
  $key_file   = 'id_rsa'
) {

  $generate_key = "sudo -u ${user} ssh-keygen -t rsa -b ${bits} -N \"\" -f ${home}/.ssh/${key_file}"

  if $create_dir {
    file { "${home}/.ssh":
      ensure => directory,
      owner  => $user,
      group  => $group
    }
  }

  if $gen {
    exec { "create_${::hostname}_ssh_key":
      cwd     => $home,
      command => $generate_key,
      creates => "${home}/.ssh/${key_file}",
      path    => $path
    }
  }
}
