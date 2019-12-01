# @summary 
#    Ensure events that modify user/group information are collected (Scored)
#
# Record events affecting the group , passwd (user IDs), shadow and gshadow (passwords) or /etc/security/opasswd 
# (old passwords, based on remember parameter in the PAM configuration) files. The parameters in this section 
# will watch the files to see if they have been opened for write or have had attribute changes (e.g. permissions) 
# and tag them with the identifier "identity" in the audit log file.
#
# Rationale:
# Unexpected changes to these files could be an indication that the system has been compromised and that an 
# unauthorized user is attempting to hide their activities or compromise additional accounts.
#
# @param enforce
#    Sets rule enforcemt. If set to true, code will be exeuted to bring the system into a comliant state.
#
# @param message
#    Message to print into the log
#
# @param log_level
#    Loglevel for the message
#
# @param level
#    Profile level
#
# @param scored
#    Indicates if a rule is scored or not
#
# @example
#   class { 'security_baseline::rules::redhat::sec_auditd_identity':
#             enforce => true,
#             message => 'What you want to log',
#             log_level => 'warning',
#   }
#
# @api private
class security_baseline::rules::redhat::sec_auditd_identity (
  Boolean $enforce  = true,
  String $message   = '',
  String $log_level = ''
) {
  if($enforce) {
    auditd::rule { 'watch identity rule 1':
      content => '-w /etc/group -p wa -k identity',
    }
    auditd::rule { 'watch identity rule 2':
      content => '-w /etc/passwd -p wa -k identity',
    }
    auditd::rule { 'watch identity rule 3':
      content => '-w /etc/gshadow -p wa -k identity',
    }
    auditd::rule { 'watch identity rule 4':
      content => '-w /etc/shadow -p wa -k identity',
    }
    auditd::rule { 'watch identity rule 5':
      content => '-w /etc/security/opasswd -p wa -k identity',
    }
  } else {
    if($facts['security_baseline']['auditd']['identity'] == false) {
      echo { 'auditd-identity':
        message  => 'Auditd has no rule to collect events changing identity.',
        loglevel => $log_level,
        withpath => false,
      }
    }
  }
}
