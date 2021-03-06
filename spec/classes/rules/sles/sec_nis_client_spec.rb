require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::sles::sec_nis_client' do
  enforce_options.each do |enforce|
    context "Suse with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          architecture: 'x86_64',
          security_baseline: {
            packages_installed: {
              ypbind: true,
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'ypbind package',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_package('ypbind')
            .with(
              'ensure' => 'absent',
            )

          is_expected.not_to contain_echo('nis-client')
        else
          is_expected.not_to contain_package('ypbind')
          is_expected.to contain_echo('nis-client')
            .with(
              'message'  => 'ypbind package',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
