require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_mcstrans' do
  enforce_options.each do |enforce|
    context "Redhat with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          architecture: 'x86_64',
          security_baseline: {
            packages_installed: {
              mcstrans_pkg: true,
              prelink: true,
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'mcstrans package',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_package('mcstrans')
            .with(
              'ensure' => 'purged',
            )

          is_expected.not_to contain_echo('mcstrans')
        else
          is_expected.not_to contain_package('mcstrans')
          is_expected.to contain_echo('mcstrans')
            .with(
              'message'  => 'mcstrans package',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
