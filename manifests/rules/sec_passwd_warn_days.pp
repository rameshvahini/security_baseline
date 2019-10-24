# @summary 
#    Ensure password expiration warning days is 7 or more (Scored)
#
# The PASS_WARN_AGE parameter in /etc/login.defs allows an administrator to notify users that their 
# password will expire in a defined number of days. It is recommended that the PASS_WARN_AGE 
# parameter be set to 7 or more days.
# 
# Rationale:
# Providing an advance warning that a password will be expiring gives users time to think of a secure 
# password. Users caught unaware may choose a simple password or write it down where it may be discovered.
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
# @param max_pass_days
#    Password expires after days
#
# @example
#   class security_baseline::special_rules::sec_passwd_warn_days {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info',
#   }
#
# @api private
class security_baseline::rules::sec_passwd_warn_days (
  Boolean $enforce            = true,
  String $message             = '',
  String $log_level           = '',
  Integer $warn_pass_days     = 7,
) {
  if($enforce) {
    file_line { 'password warning days':
      ensure => present,
      path   => '/etc/login.defs',
      line   => "PASS_WARN_AGE ${warn_pass_days}",
      match  => '^#?PASS_WARN_AGE',
    }

    $local_users = pick($facts['local_users'], {})

    $local_users.each |String $user, Hash $attributes| {
      if $attributes['password_expires_days'] != 'never' and $attributes['warn_days_between_password_change'] != $warn_pass_days {
        exec { "/bin/chage --warndays ${warn_pass_days} ${user}": }
      }
    }
  } else {
    if($facts['security_baseline']['pw_data']['pass_warn_age_status']) {
      echo { 'pass-warn-days':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}