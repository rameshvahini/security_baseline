# @summary 
#    Ensure permissions on /etc/cron.daily are configured (Scored)
#
# This directory contains system cron jobs that need to run on an daily basis. The files in this 
# directory cannot be manipulated by the crontab command, but are instead edited by system administrators 
# using a text editor. The commands below restrict read/write and search access to user and group root, 
# preventing regular users from accessing this directory.
#
# Rationale:
# Granting write access to this directory for non-privileged users could provide them the means for gaining 
# unauthorized elevated privileges. Granting read access to this directory could give an unprivileged user 
# insight in how to gain elevated privileges or circumvent auditing controls.
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
#   class security_baseline::rules::redhat::sec_cron_daily {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::redhat::sec_cron_daily (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if($enforce) {

    file { '/etc/cron.daily':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
      }

  } else {

    if(
      ($facts['security_baseline']['cron']['/etc/cron.daily']['uid'] != 0) or
      ($facts['security_baseline']['cron']['/etc/cron.daily']['gid'] != 0) or
      ($facts['security_baseline']['cron']['/etc/cron.daily']['mode'] != 0700)
    ) {
      echo { 'etc-cron-daily':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
