# @summary
#    Check a security rule. 
#
# Check a security rule, enforce it or just monitor it and log into the Puppet log files.
#
# @param rulename
#    Name of the rule for loggting
#
# @param active
#    Sets a rule active or inactive. Inactive rules will not be used
#
# @param description
#    Information about the rule. Currently only for information.
#
# @param enforce
#    Sets rule enforcemt. If set to true, code will be exeuted to bring the system into a comliant state.
#
# @param class 
#    Class implementing the rule. This might be a class with this module but can reference an external class as well. 
#    This makes this module highly generic.
#
# @param check
#    A hash describing the fact for the test and the desired value
# 
# @param message
#    Message to print into the log
#
# @param loglevel
#    Loglevel for the message
#
# @param config_data
#    Additional configuration data, especially if external security modules are used to provide configuration data
#    to those modules
#
# @example
#   security_baseline::sec_check { '1.1.2': 
#       rulename => 'tmp_partition',
#       active => true,
#       description => 'The /tmp directory ...',
#       enforce => true,
#       class => '::security_baseline::rules::sec_tmp_partition',
#       check => {
#         fact_name => 'tmp_partition',
#         fact_value => '/tmp',
#       },
#       message => 'Not in compliance with rule 1.1.2. No seperate directory for /tmp.',
#       loglevel => 'warning',
#   }
define security_baseline::sec_check (
  String $rulename,
  String $description,
  Boolean $enforce,
  String $class,
  Hash $check,
  String $message = '',
  String $loglevel = 'warning',
  Boolean $active = true,
  Optional[Hash] $config_data = {},
) {

    if($active) {

      if($::security_baseline::debug) {
        echo{"Applying rule ${rulename}":
          loglesel => 'debug',
          withpath => false,
        }
      }

      $fact_name = $check['fact_name']
      if($fact_name != '') {

        $fact_value = $check['fact_value']
        $current_value = $facts[$fact_name]

        if($current_value != $fact_value) {

          echo { "Fact ${fact_name} should have value '${fact_value}' but has current value '${current_value}'":
            loglevel => $loglevel,
            withpath => false,
          }

          $my_msg = $message
          $my_level = $loglevel
          $my_state = 'not compliant'

        } else {

          # fact contains expected value
          $my_msg = ''
          $my_level = 'ok'
          $my_state = 'compliant'
        }

      } else {

        # if no fact name is available assume test is compliant
        $my_msg = ''
        $my_level = 'ok'
        $my_state = 'compliant'
      }

      # concat::fragment { $title:
      #  content => epp('security_baseline/logentry.epp', {
      #    'rulenr'    => $title,
      #    'rule'      => $rulename,
      #    'desc'      => $description,
      #    'msg'       => $my_msg,
      #    'level'     => $my_level,
      #    'rulestate' => $my_state,
      #  }),
      #  target  => $::security_baseline::logfile,
      #}

      ::security_baseline::logging { $title:
        rulenr    => $title,
        rule      => $rulename,
        desc      => $description,
        level     => $my_level,
        msg       => $my_msg,
        rulestate => $my_state,
      }

      if($class =~ /^::security_baseline::rules::/) {
        $data = {
          'enforce' => $enforce,
          'message' => $message,
          'loglevel' => $loglevel,
        }
      } else {
        $data = {
          'enforce' => $enforce,
          'message' => $message,
          'loglevel' => $loglevel,
          'logfile' => $::security_baseline::logfile,
        }
      }


      $merged_data = merge($data, $config_data)

      class { $class:
        * => $merged_data
      }

      #if(empty($config_data)) {

      #  class { $class:
      #    enforce  => $enforce,
      #    message  => $message,
      #    loglevel => $loglevel,
      #    logfile  => $::security_baseline::logfile,
      #  }

      # } else {

      #  class { $class:
      #    enforce     => $enforce,
      #    message     => $message,
      #    loglevel    => $loglevel,
      #    logfile     => $::security_baseline::logfile,
      #    config_data => $config_data,
      #  }
      # }

    } # rule active
}
