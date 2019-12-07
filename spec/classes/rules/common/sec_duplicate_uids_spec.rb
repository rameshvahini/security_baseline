require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::common::sec_duplicate_uids' do
  on_supported_os.each do |os, os_facts|
    enforce_options.each do |enforce|
      context "on #{os} with enforce = #{enforce}" do
        let(:facts) do
          os_facts.merge(
            'srv_avahi' => 'enabled',
            'security_baseline' => {
              'duplicate_uids' => '123456',
            },
          )
        end
        let(:params) do
          {
            'enforce' => enforce,
            'message' => 'duplicate uids service',
            'log_level' => 'warning',
          }
        end

        it {
          is_expected.to compile
          if enforce
            is_expected.not_to contain_echo('duplicate-uids')
          else
            is_expected.to contain_echo('duplicate-uids')
              .with(
                'message'  => 'duplicate uids service',
                'loglevel' => 'warning',
                'withpath' => false,
              )
          end
        }
      end
    end
  end
end
