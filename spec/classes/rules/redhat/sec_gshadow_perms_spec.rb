require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_gshadow_perms' do
  enforce_options.each do |enforce|
    context "on redHat with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          architecture: 'x86_64',
          'security_baseline' => {
            'file_permissions' => {
              'gshadow' => {
                'combined' => '0-0-777',
              },
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'gshadow file permissions',
          'log_level' => 'warning',
        }
      end

      it {
        is_expected.to compile
        if enforce
          is_expected.to contain_file('/etc/gshadow')
            .with(
              'ensure' => 'present',
              'owner'  => 'root',
              'group' => 'root',
              'mode' => '0000',
            )
          is_expected.not_to contain_echo('gshadow_perms')
        else
          is_expected.not_to contain_file('/etc/gshadow')
          is_expected.to contain_echo('gshadow_perms')
            .with(
              'message'  => 'gshadow file permissions',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      }
    end
  end
end
