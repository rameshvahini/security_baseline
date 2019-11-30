# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include security_baseline::world_writeable_files_cron
class security_baseline::world_writeable_files_cron {
  $filename = '/root/world-writable-files.txt'

  file { '/usr/local/sbin/world-wrirable-files.sh':
    ensure  => file,
    content => epp('security_baseline/world-writeable-files.epp', { filename => $filename }),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  file { '/etc/cron.d/woirld-writebale-files.cron':
    ensure => file,
    source => 'puppet:///modules/security_baseline/world-writeable-files.cron',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}