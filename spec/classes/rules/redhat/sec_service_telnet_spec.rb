require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_service_telnet' do
  enforce_options.each do |enforce|
    context "RedHat with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          architecture: 'x86_64',
          srv_echo: true,
          security_baseline: {
            xinetd_services: {
              srv_echo: true,
              srv_telnet: true,
            },
            services_enabled: {
              srv_telnet: true,
            },
          },
        }
      end

      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'servive telnet',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_service('telnet')
            .with(
              'ensure' => 'stopped',
              'enable' => false,
            )

          is_expected.not_to contain_echo('telnet-service')
        else
          is_expected.not_to contain_service('telnet')
          is_expected.to contain_echo('telnet-service')
            .with(
              'message'  => 'servive telnet',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
