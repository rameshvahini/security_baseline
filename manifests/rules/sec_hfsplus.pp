# @summary 
#    Ensure mounting of hfsplus filesystems is disabled (Scored)
#
# The hfsplus filesystem type is a hierarchical filesystem designed to replace 
# hfs that allows you to mount Mac OS filesystems.
#
# Rationale:
# Removing support for unneeded filesystem types reduces the local attack surface 
# of the system. If this filesystem type is not needed, disable it.
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
#   class security_baseline::rules::sec_hfsplus {
#       enforce => true,
#       message => 'Test',
#       loglevel => 'info'
#   }
#
# @api private
class security_baseline::rules::sec_hfsplus (
  Boolean $enforce = true,
  String $message = '',
  String $loglevel = ''
) {
  if $enforce {
    kmod::install { 'hfsplus':
      command => '/bin/true',
    }
  }
}
