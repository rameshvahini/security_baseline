require 'facter/helpers/check_service_enabled'

# frozen_string_literal: true

# rsh_service.rb
# Check if rsh services is enabled

Facter.add('srv_rsh') do
  confine osfamily: 'RedHat'
  setcode do
    rsh = check_service_is_enabled('rsh.socket')
    rlogin = check_service_is_enabled('rlogin.socket')
    rexec = check_service_is_enabled('recex.socket')

    if (rsh == 'enbaled') || (rlogin == 'enabled') || (rexec == 'enabled')
      'enabled'
    else
      'disabled'
    end
  end
end