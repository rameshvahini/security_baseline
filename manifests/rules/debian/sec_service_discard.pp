# @summary 
#    Ensure discard services are not enabled (Scored)
#
# discardis a network service that simply discards all data it receives. This service is 
# intended for debugging and testing purposes. It is recommended that this service be 
# disabled.
#
# Rationale:
# Disabling this service will reduce the remote attack surface of the system.
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
#   class security_baseline::rules::debian::sec_service_discard {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::debian::sec_service_discard (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if(has_key($facts['security_baseline']['inetd_services'], 'srv_discard')) {
    if($enforce) {
      if($facts['security_baseline']['inetd_services']['srv_discard']['status']) {
        file_line { 'discard_disable':
          line     => 'disable     = yes',
          path     => $facts['security_baseline']['inetd_services']['srv_discard']['filename'],
          match    => 'disable.*=',
          multiple => true,
        }
      }
    } else {
      if($facts['security_baseline']['inetd_services']['srv_discard']['status']) {
        echo { 'discard-inetd':
          message  => $message,
          loglevel => $log_level,
          withpath => false,
        }
      }
    }
  }
}
