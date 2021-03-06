# @summary 
#    Disable Automounting (Scored)
#
# autofs allows automatic mounting of devices, typically including CD/DVDs and USB drives.
#
# Rationale:
# With automounting enabled anyone with physical access could attach a USB drive or disc and have its 
# contents available in system even if they lacked permissions to mount it themselves.
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
#   class security_baseline::rules::common::sec_automounting {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::common::sec_automounting (
  Boolean $enforce = true,
  String $message = '',
  String $log_level = ''
) {
  if $enforce {

    if $facts['security_baseline']['services_enabled']['srv_autofs'] == 'enabled' {

        class { 'autofs':
          service_ensure => 'stopped',
          service_enable => false,
        }
      }

  } else {

    if($facts['security_baseline']['services_enabled']['srv_autofs'] == 'enabled') {
      echo { 'automount':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }

  }
}
