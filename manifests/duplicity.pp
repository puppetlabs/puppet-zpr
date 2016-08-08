define zpr::duplicity (
  $target,
  $home,
  $key_id, #toremove
  $files               = $name,
  $ensure              = present, #toremove
  $user                = 'zpr_proxy',
  $offsite_config_file = '.offsite_config',
  $full_every          = '30D',
  $keep                = '8W',
  $hour                = '1',
  $minute              = '10',
  $task_spooler        = '/usr/bin/tsp -E',
  $options             = undef #toremove
) {

  include zpr::duplicity_pkg
  include zpr::gpg
  include zpr::task_spooler

  if is_array($files) {
    $join_files   = join( $files, ' --include ' )
    $source_files = "--include ${join_files}"
  }
  else {
    $source_files = $files
  }

  cron { "Duplicity: backup of ${title}":
    ensure  => $ensure,
    user    => $user,
    hour    => $hour,
    minute  => $minute,
    command => join([
      $task_spooler,
      '/bin/bash -c',
      '" time=$(date +\%s);',
      "${home}/run_duplicity",
      $source_files,
      $target,
      $full_every,
      $keep,
      '"',
    ], ' ')
  }
}
