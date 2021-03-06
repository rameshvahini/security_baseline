# @summary 
#    Cron to run search for unowned files
#
# Create a cron job to run a search for unowned files.
#
# @param dirs_to_exclude
#    Array of directories to exclude from search.
#
# @example
#   include security_baseline::unowned_files_cron
class security_baseline::unowned_files_cron (
  Array $dirs_to_exclude = [],
) {
  $unowned_user = '/usr/share/security_baseline/data/unowned_files_user.txt'
  $unowned_group = '/usr/share/security_baseline/data/unowned_files_group.txt'

  file { '/usr/share/security_baseline/bin/unowned_files.sh':
    ensure  => present,
    content => epp('security_baseline/unowned-files.epp', {
      unowned_user    => $unowned_user,
      unowned_group   => $unowned_group,
      dirs_to_exclude => $dirs_to_exclude,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  $min = fqdn_rand(60, 'aghfsbcHDFBCWDOFBCQWFQBFGH')

  file { '/etc/cron.d/unowned-files.cron':
    ensure  => present,
    content => epp('security_baseline/unowned-files.cron.epp', {min => $min}),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
