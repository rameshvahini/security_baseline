# @summary 
#    Ensure the MCS Translation Service (mcstrans) is not installed (Scored)
#
# The mcstransd daemon provides category label information to client processes requesting 
# information. The label translations are defined in /etc/selinux/targeted/setrans.conf
#
# Rationale:
# Since this service is not used very often, remove it to reduce the amount of potentially 
# vulnerable code running on the system.
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
#   class security_baseline::rules::sles::sec_mcstrans {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::sles::sec_mcstrans (
  Boolean $enforce = true,
  String $message = '',
  String $log_level = ''
) {
  if($enforce) {
    ensure_packages(['mcstrans'], {
      ensure => 'absent',
    })
  } else {
    if($facts['security_baseline']['packages_installed']['mcstrans_pkg']) {
      echo { 'mcstrans':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
