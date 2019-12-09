require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::common::sec_root_gid' do
  on_supported_os.each do |os, os_facts|
    enforce_options.each do |enforce|
      context "on #{os}" do
        let(:facts) do
          os_facts.merge(
            'security_baseline' => {
              'accounts' => {
                'root_gid' => 1,
              },
            },
          )
        end
        let(:params) do
          {
            'enforce' => enforce,
            'message' => 'root gid',
            'log_level' => 'warning',
          }
        end

        it { is_expected.to compile }
        it do
          if enforce
            is_expected.to contain_user('root')
              .with(
                'ensure' => 'present',
                'gid'    => '0',
              )

            is_expected.not_to contain_echo('root-gid')
          else
            is_expected.not_to contain_user('root')
            is_expected.to contain_echo('root-gid')
              .with(
                'message'  => 'root gid',
                'loglevel' => 'warning',
                'withpath' => false,
              )

          end
        end
      end
    end
  end
end