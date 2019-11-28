# @summary A short summary of the purpose of this class
#
# A description of what this class does
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
#   class security_baseline::rules::redhat::sec_motd_permissions_gid {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::redhat::sec_motd_permissions_gid (
  Boolean $enforce = true,
  String $message = '',
  String $log_level = ''
) {
  if(!$enforce) and ($facts['security_baseline']['motd']['gid'] != 0) {

    echo { 'issue-os-gid':
      message  => $message,
      loglevel => $log_level,
      withpath => false,
    }

  }
}
