# @summary 
#    Ensure SSH Idle Timeout Interval is configured (Scored)
#
# The two options ClientAliveInterval and ClientAliveCountMax control the timeout of ssh sessions. When 
# the ClientAliveInterval variable is set, ssh sessions that have no activity for the specified length 
# of time are terminated. When the ClientAliveCountMax variable is set, sshd will send client alive 
# messages at every ClientAliveInterval interval. When the number of consecutive client alive messages 
# are sent with no response from the client, the ssh session is terminated. For example, if the 
# ClientAliveInterval is set to 15 seconds and the ClientAliveCountMax is set to 3, the client ssh session 
# will be terminated after 45 seconds of idle time.
#
# Rationale:
# Having no timeout value associated with a connection could allow an unauthorized user access to another user's 
# ssh session (e.g. user walks away from their computer and doesn't lock the screen). Setting a timeout value at 
# least reduces the risk of this happening.
#
# While the recommended setting is 300 seconds (5 minutes), set this timeout value based on site policy. The 
# recommended setting for ClientAliveCountMax is 0. In this case, the client session will be terminated after 
# 5 minutes of idle time and no keepalive messages will be sent.
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
# @param client_alive_interval
#    The client alive imterval
#
# @param client_alive_cout_max
# The client alive cout max
#
# @example
#   class security_baseline::rules::common::sec_sshd_timeouts {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::common::sec_sshd_timeouts (
  Boolean $enforce               = true,
  String $message                = '',
  String $log_level              = '',
  Integer $client_alive_interval = 300,
  Integer $client_alive_cout_max =  0,
) {
  if($facts['security_baseline']['sshd']['package']) {
    if($enforce) {

      file_line { 'sshd-timeouts':
        ensure => present,
        path   => '/etc/ssh/sshd_config',
        line   => "ClientAliveInterval ${client_alive_interval}",
        match  => '^ClientAliveInterval.*',
        notify => Exec['reload-sshd'],
      }

      file_line { 'sshd-timeouts-2':
        ensure => present,
        path   => '/etc/ssh/sshd_config',
        line   => "ClientAliveCountMax ${client_alive_cout_max}",
        match  => '^ClientAliveCountMax.*',
        notify => Exec['reload-sshd'],
      }

    } else {
      if(
        ($facts['security_baseline']['sshd']['clientaliveinterval'] != '300') or
        ($facts['security_baseline']['sshd']['clientalivecountmax'] != '0')
      ) {
        echo { 'sshd-timeouts':
          message  => $message,
          loglevel => $log_level,
          withpath => false,
        }
      }
    }
  }
}
