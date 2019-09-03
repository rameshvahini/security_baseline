# @summary 
#    Ensure rsh server is not enabled (Scored)
#
# The Berkeley rsh-server ( rsh , rlogin , rexec ) package contains legacy services that exchange credentials 
# in clear-text.
#
# Rationale:
# These legacy services contain numerous security exposures and have been replaced with the more secure SSH package.
#
# @param enforce
#    Enforce the rule or just test and log
#
# @param message
#    Message to print into the log
#
# @param loglevel
#    The loglevel for the above message
#
# @example
#   class security_baseline::rules::sec_rsh {
#       enforce => true,
#       message => 'Test',
#       loglevel => 'info'
#   }
#
# @api private
class security_baseline::rules::sec_rsh (
  Boolean $enforce = true,
  String $message = '',
  String $loglevel = ''
) {
  if($enforce) {

    service { 'rsh.socket':
      ensure => 'stopped',
      enable => false,
    }

    service { 'rlogin.socket':
      ensure => 'stopped',
      enable => false,
    }

    service { 'rexec.socket':
      ensure => 'stopped',
      enable => false,
    }

  } else {

    if($::srv_rsh == 'enabled') {
      echo { 'rsh-service':
        message  => $message,
        loglevel => $loglevel,
        withpath => false,
      }
    }
  }
}
