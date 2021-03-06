# @summary Ensure SELinux is not disabled in bootloader configuration (Scored)
#
# Configure SELINUX to be enabled at boot time and verify that it has not been overwritten by the grub boot parameters.
#
# Rationale:
# SELinux must be enabled at boot time in your grub configuration to ensure that the controls it provides are not overridden.
#
# @param enforce
#    Enforce the rule or just test and log
#
# @param message
#    Message to print into the log
#
# @param log_level
#    The log_level for the above message
#
# @example
#   class security_baseline::rules::debian::sec_selinux_bootloader {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::debian::sec_selinux_bootloader (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if($enforce) {
    if(
      (($facts['security_baseline']['selinux']['bootloader'] == false)) and
      ($facts['operatingsystem'] == 'Debian')
    ) {
      echo { 'bootloader-selinux-activates':
        message  => 'Running selinux-activate',
        loglevel => 'warning',
        withpath => false,
      }

      ensure_packages(['selinux-basics','selinux-policy-default'], {ensure => installed})

      exec { 'activate selinux':
        command => 'selinux-activate',
        path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        before  => Exec['selinux-grub-config'],
        require => Package['selinux-policy-default', 'selinux-basics']
      }
    } else {
      echo { 'bootloader-selinux-not-activates':
        message  => 'Not running selinux-activate',
        loglevel => 'warning',
        withpath => false,
      }
    }

    file_line { 'cmdline_definition':
      line   => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
      path   => '/etc/default/grub',
      match  => '^GRUB_CMDLINE_LINUX_DEFAULT',
      notify => Exec['selinux-grub-config'],
    }
    kernel_parameter { 'selinux':
      ensure => present,
      value  => '1',
      notify => Exec['selinux-grub-config']
    }
    kernel_parameter { 'security':
      ensure => present,
      value  => 'selinux',
      notify => Exec['selinux-grub-config']
    }
    kernel_parameter { 'enforcing':
      ensure => present,
      value  => '1',
      notify => Exec['selinux-grub-config']
    }
    exec {'selinux-grub-config':
      command     => 'update-grub',
      path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      refreshonly => true,
    }
  } else {
    if($facts['security_baseline']['selinux']['bootloader'] == false) {
      echo { 'bootloader-selinux':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
