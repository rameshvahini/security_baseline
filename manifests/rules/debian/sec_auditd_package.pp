# @summary 
#    Ensure auditd is installed (Scored)
#
# auditd is the userspace component to the Linux Auditing System. It's responsible for writing audit 
# records to the disk.
#
# Rationale:
# The capturing of system events provides system administrators with information to allow them to 
# determine if unauthorized access to their system is occurring.
#
# @param enforce
#    Sets rule enforcemt. If set to true, code will be exeuted to bring the system into a comliant state.
#
# @param message
#    Message to print into the log
#
# @param log_level
#    Loglevel for the message
#
# @example
#   class { 'security_baseline::rules::debian::sec_auditd_package':
#             enforce => true,
#             message => 'What you want to log',
#             log_level => 'warning',
#   }
#
# @api private
class security_baseline::rules::debian::sec_auditd_package (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if ($enforce) {
    #if(!defined(Package['auditd'])) {
    #  Package { 'auditd':
    #    ensure => installed,
    #  }
    #}
    #if(!defined(Package['audispd-plugins'])) {
    #  Package { 'audispd-plugins':
    #    ensure => installed,
    #  }
    #}

    ensure_packages(['auditd', 'audispd-plugins'], {
      ensure => installed
    })
  } else {
    if(
      ($facts['security_baseline']['packages_installed']['auditd'] == false) or
      ($facts['security_baseline']['packages_installed']['audispd-plugins'] == false)
    ) {
      echo { 'auditd-packages':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
