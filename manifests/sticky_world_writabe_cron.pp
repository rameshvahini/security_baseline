# @summary 
#    Create cron job for searching world writable dir3ctories with sticky bit
#
# Create a cron ob for the search for world writable directories with sticky bit set.
#
# @param dirs_to_exclude
#    Array of directories to exclude from search.
#
# @example
#   include security_baseline::sticky_world_writabe_cron
class security_baseline::sticky_world_writabe_cron (
  Array $dirs_to_exclude = [],
) {
  $filename = '/root/world-writable-files.txt'

  file { '/usr/share/security_baseline/bin/sticy-world-writable.sh':
    ensure  => present,
    content => epp('security_baseline/sticky-world-writeable.epp', {
      filename        => $filename,
      dirs_to_exclude => $dirs_to_exclude
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  $min = fqdn_rand(60, 'ah  ue65^b  gdf^zrbzcê2zf^b w')

  file { '/etc/cron.d/sticky-world-writebale.cron':
    ensure  => present,
    content => epp('security_baseline/sticky-world-writeable.cron.epp', {min => $min}),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
