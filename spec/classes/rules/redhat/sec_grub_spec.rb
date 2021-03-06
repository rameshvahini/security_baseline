require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_grub' do
  enforce_options.each do |enforce|
    context "Redhat with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          operatingsystemmajrelease: '6',
          architecture: 'x86_64',
          'security_baseline' => {
            'grub' => {
              'grub.cfg' => {
                'uid' => 0,
                'gid' => 17,
                'mode' => 420,
              },
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'grub config file settings',
          'log_level' => 'warning',
        }
      end

      it {
        is_expected.to compile

        if enforce
          is_expected.not_to contain_echo('grub-grub-cfg')
          is_expected.to contain_file('/boot/grub/grub.cfg')
            .with(
              'ensure' => 'present',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0600',
            )
        else
          is_expected.not_to contain_file('/boot/grub2/grub.cfg')
          is_expected.to contain_echo('grub-grub-cfg')
            .with(
              'message'  => 'grub config file settings',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      }
    end
  end
end
