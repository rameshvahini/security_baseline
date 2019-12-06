require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::common::sec_aide' do
  on_supported_os.each do |os, os_facts|

    enforce_options.each do |enforce|
      context "on #{os}" do
        let(:facts) { 
          os_facts.merge(
            'security_baseline' => {
              'aide' => {
                'version' =>  '6.1.2',
                'status' => 'not installed',
              }
            }
          )
        }
        let(:params) do
          {
            'enforce' => enforce,
            'message' => 'aide package',
            'log_level' => 'warning',
          }
        end

        it { is_expected.to compile }
        it do
          if enforce
            is_expected.to contain_package('aide')
              .that_notifies('Exec[aidedb]')
            is_expected.to contain_exec('aidedb')
              .with(
                command: 'aide --init',
              )
              .that_notifies('Exec[rename_aidedb]')
            is_expected.to contain_exec('rename_aidedb')
              .with(
                command: 'mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz',
              )
          else
            is_expected.to contain_echo('aide')
              .with(
                'message'  => 'aide package',
                'loglevel' => 'warning',
                'withpath' => false,
              )
            
          end
        end
      end
    end
  end
end