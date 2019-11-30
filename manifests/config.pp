# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include security_baseline::config
class security_baseline::config {
  file { '/usr/local/security_baseline_scripts':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/root_path_integrity.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/root_path_integrity.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_user_home_dirs.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_user_home_dirs.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_home_dir_permissions.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_home_dir_permissions.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_home_dir_owner.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_home_dir_owner.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/ss_write.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_dot_files_write.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_forward_files.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_forward_files.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_netrc_files.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_netrc_files.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_netrc_files_write.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_netrc_files_write.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_rhosts_files.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_rhosts_files.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/usr/local/security_baseline_scripts/check_passwd_group_exist.sh':
    ensure => file,
    source => 'puppet:///modules/security_baseline/check_passwd_group_exist.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
}