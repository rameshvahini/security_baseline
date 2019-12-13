require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::debian::sec_service_talk' do
  enforce_options.each do |enforce|
    context "on Debian with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          architecture: 'x86_64',
          security_baseline: {
            inetd_services: {
              srv_talk: {
                status: true,
                filename: '/etc/xinetd.d/talk',
              },
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'service talk',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_file_line('talk_disable')
          .with(
            'line'     => 'disable     = yes',
            'path'     => '/etc/xinetd.d/talk',
            'match'    => 'disable.*=',
            'multiple' => true,
          )

          is_expected.not_to contain_echo('talk-inetd')
        else
          is_expected.not_to contain_service('talk_disable')
          is_expected.to contain_echo('talk-inetd')
            .with(
              'message'  => 'service talk',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
