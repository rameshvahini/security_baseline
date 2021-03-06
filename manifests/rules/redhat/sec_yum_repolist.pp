# @summary 
#    Ensure package manager repositories are configured (Not Scored)
#
# Systems need to have package manager repositories configured to ensure they receive the latest patches and updates.
#
# Rationale:
# If a system's package repositories are misconfigured important patches may not be identified or a rogue repository could 
# introduce compromised software.
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
#   class security_baseline::rules::redhat::sec_yum_repolist {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::redhat::sec_yum_repolist (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if(has_key($facts['security_baseline'], 'yum') and $facts['security_baseline']['yum']['repolist_config'] == false) {
    echo { 'package-repo-config':
      message  => $message,
      loglevel => $log_level,
      withpath => false,
    }
  }
}
