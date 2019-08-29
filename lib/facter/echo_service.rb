# frozen_string_literal: true

# echo_service.rb
# Check if echo services are switched on

Facter.add('srv_daytime') do
    confine :osfamily => 'RedHat'
    setcode do
      ret = false
      srv = Facter::Core::Execution.exec("chkconfig --list 2>/dev/null | sed -e 's/\s//g' | grep echo")
      if srv.empty? then
        ret = false
      else
        srv.each do |line|
          data = line.split(%r{:}).strip()
          if data[1].strip().downcase() != 'off' then
            ret = true
          end
        end
      end
  
      ret
    end
  end
  