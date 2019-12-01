# @summary 
#    Ensure auditd service is enabled (Scored)
#
# Turn on the auditd daemon to record system events.
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
#   class { 'security_baseline::rules::redhat::sec_auditd_service':
#             enforce => true,
#             message => 'What you want to log',
#             log_level => 'warning',
#   }
#
# @api private
class security_baseline::rules::redhat::sec_auditd_service (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if($enforce) {
    package { 'audit':
      ensure => installed,
    }

    service { 'auditd':
      ensure  => running,
      enable  => true,
      require => Package['audit']
    }

  } else {
    if($facts['security_baseline']['auditd']['srv_auditd'] == false) {
      echo { 'auditd-max-log-action':
        message  => 'Auditd servive should be enabled and running.',
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
