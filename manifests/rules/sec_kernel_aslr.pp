# @summary 
#    Ensure address space layout randomization (ASLR) is enabled (Scored)
#
# Address space layout randomization (ASLR) is an exploit mitigation technique which randomly 
# arranges the address space of key data areas of a process.
# 
# Rationale:
# Randomly placing virtual memory regions will make it difficult to write memory page exploits 
# as the memory placement will be consistently shifting.
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
#   class security_baseline::rules::sec_kernel_aslr {
#       enforce => true,
#       message => 'Test',
#       log_level => 'info'
#   }
#
# @api private
class security_baseline::rules::sec_kernel_aslr (
  Boolean $enforce = true,
  String $message = '',
  String $log_level = ''
) {
  if($enforce) {

    sysctl { 'kernel.randomize_va_space':
      value => 2,
    }

  } else {

    if($::kernel_aslr != 2) {

      echo { 'kernel-aslr':
        message   => $message,
        log_level => $log_level,
        withpath  => false,
      }

    }
  }
}
