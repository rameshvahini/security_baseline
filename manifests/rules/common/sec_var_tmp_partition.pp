# @summary 
#    Ensure separate partition exists for /var/tmp (Scored)
#
# The /var/tmp directory is a world-writable directory used for temporary storage by all users and some applications.
#
# Rationale:
# Since the /var/tmp directory is intended to be world-writable, there is a risk of resource exhaustion if it is 
# not bound to a separate partition. In addition, making /var/tmp its own file system allows an administrator to 
# set the noexec option on the mount, making /var/tmp useless for an attacker to install executable code. 
# It would also prevent an attacker from establishing a hardlink to a system setuid program and wait for it to 
# be updated. Once the program was updated, the hardlink would be broken and the attacker would have his own 
# copy of the program. If the program happened to have a security vulnerability, the attacker could continue to 
# exploit the known flaw.
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
#   class security_baseline::rules::common::sec_var_tmp_partition {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::common::sec_var_tmp_partition (
  Boolean $enforce = true,
  String $message = '',
  String $log_level = ''
) {
  if (has_key($facts, 'security_baseline')) and
    ($facts['security_baseline']['partitions']['var_tmp']['partition'] == undef) {

    echo { 'var-tmp-partition':
      message  => $message,
      loglevel => $log_level,
      withpath => false,
    }
  }
}
