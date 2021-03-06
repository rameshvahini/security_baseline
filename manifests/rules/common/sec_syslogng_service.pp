# @summary 
#    Ensure syslog-ng service is enabled (Scored)
#
# Once the syslog-ng package is installed it needs to be activated.
#
# Rationale:
# If the syslog-ng service is not activated the system may default to the syslogd service or lack 
# logging instead.
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
#   class security_baseline::rules::common::sec_syslogng_service {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::common::sec_syslogng_service (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if($enforce) {
    if(!defined(Package['syslog-ng'])) {

      ensure_packages(['rsyslog'], {
        ensure => absent,
      })

      ensure_packages(['syslog-ng'], {
        ensure => installed,
      })
    }
    if(!defined(Service['syslog-ng'])) {

      ensure_resource('service', ['syslog-ng'], {
        ensure  => running,
        enable  => true,
        require => Package['syslog-ng'],
      })

    }
  }
}
