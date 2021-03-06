require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_setroubleshoot' do
  enforce_options.each do |enforce|
    context "RedHat with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          architecture: 'x86_64',
          security_baseline: {
            packages_installed: {
              setroubleshoot: true,
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'setroubleshoot package',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_package('setroubleshoot')
            .with(
              'ensure' => 'purged',
            )

          is_expected.not_to contain_echo('setroubleshoot')
        else
          is_expected.not_to contain_package('setroubleshoot')
          is_expected.to contain_echo('setroubleshoot')
            .with(
              'message'  => 'setroubleshoot package',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
