# @summary 
#    Ensure password creation requirements are configured (Scored)
#
# The pam_pwquality.so module checks the strength of passwords. It performs checks such as making sure a password is not a 
# dictionary word, it is a certain length, contains a mix of characters (e.g. alphabet, numeric, other) and more. The 
# following are definitions of the pam_pwquality .so options.
#
# - try_first_pass - retrieve the password from a previous stacked PAM module. If not available, then prompt the user for a password.
# - retry=3 - Allow 3 tries before sending back a failure.
#
# The following options are set in the /etc/security/pwquality.conf file:
# - minlen = 14 - password must be 14 characters or more
# - dcredit = -1 - provide at least one digit
# - ucredit = -1 - provide at least one uppercase character
# - ocredit = -1 - provide at least one special character
# - lcredit = -1 - provide at least one lowercase character
#
# The settings shown above are one possible policy. Alter these values to conform to your own organization's password policies.
#
# Rationale:
# Strong passwords protect systems from being hacked through brute force methods.
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
# @param minlen
#    Minimal password length
#
# @param dcredit
#    Minimum number of digits a password must contain
#
# @param ucredit
#    Minimum number of upper case characters a apassword mt contain
#
# @param ocredit
#    Minimum number of special characters a password must contain
#
# @param lcredit
#    Minimum number of lower case characters a password must contain
#
# @example
#   class security_baseline::rules::debian::ssec_pam_pw_requirements {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info',
#   }
#
# @api private
class security_baseline::rules::debian::sec_pam_pw_requirements (
  Boolean $enforce            = true,
  String $message             = '',
  String $log_level           = '',
  Integer $minlen             = 14,
  Integer $dcredit            = -1,
  Integer $ucredit            = -1,
  Integer $ocredit            = -1,
  Integer $lcredit            = -1,
) {
  $services = [
    'common-password',
  ]

  if($enforce) {
    if(!defined(Package['libpam-pwquality'])) {
      ensure_packages(['libpam-pwquality'], {
        ensure => installed,
      })
    }

    file_line { 'pam minlen':
      ensure => 'present',
      path   => '/etc/security/pwquality.conf',
      line   => "minlen = ${minlen}",
      match  => '^#?minlen',
    }

    file_line { 'pam dcredit':
      ensure => 'present',
      path   => '/etc/security/pwquality.conf',
      line   => "dcredit = ${dcredit}",
      match  => '^#?dcredit',
    }

    file_line { 'pam ucredit':
      ensure => 'present',
      path   => '/etc/security/pwquality.conf',
      line   => "ucredit = ${ucredit}",
      match  => '^#?ucredit',
    }

    file_line { 'pam ocredit':
      ensure => 'present',
      path   => '/etc/security/pwquality.conf',
      line   => "ocredit = ${ocredit}",
      match  => '^#?ocredit',
    }

    file_line { 'pam lcredit':
      ensure => 'present',
      path   => '/etc/security/pwquality.conf',
      line   => "lcredit = ${lcredit}",
      match  => '^#?lcredit',
    }

    if($facts['operatingsystem'] == 'Ubuntu') {
      $data = {
        ensure    => present,
        service   => 'common-password',
        type      => 'password',
        control   => 'requisite',
        module    => 'pam_pwquality.so',
        arguments => [
          'try_first_pass',
          'retry=3',
          "minlen=${minlen}",
        ]
      }
    } else {
      $data = {
        ensure    => present,
        service   => 'common-password',
        type      => 'password',
        control   => 'requisite',
        module    => 'pam_pwquality.so',
        arguments => [
          'retry=3',
        ]
      }
    }
    Pam { 'pam_pwquality common-password':
      * => $data,
    }
  } else {
    unless ($facts['security_baseline']['pam']['pwquality']['status']) {
      echo { 'pam-password-complexity':
        message  => $message,
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
