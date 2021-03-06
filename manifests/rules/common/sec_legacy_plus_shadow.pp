# @summary 
#    Ensure no legacy "+" entries exist in /etc/shadow (Scored)
#
# The character + in various files used to be markers for systems to insert data from NIS maps at a 
# certain point in a system configuration file. These entries are no longer required on most systems, 
# but may exist in files that have been imported from other platforms.
#
# Rationale:
# These entries may provide an avenue for attackers to gain privileged access on the system.
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
#   class security_baseline::rules::common::sec_legacy_plus_shadow {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::common::sec_legacy_plus_shadow (
  $enforce          = true,
  String $message   = '',
  String $log_level = ''
) {
  if ($facts['security_baseline']['legacy_plus']['shadow'] != 'none') {
    echo { 'legacy-plus-shadow':
      message  => $message,
      loglevel => $log_level,
      withpath => false,
    }
  }
}
