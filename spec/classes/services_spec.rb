require 'spec_helper'

describe 'security_baseline::services' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to compile

        if os_facts[:operatingsystemmajrelease] == '6' && os_facts[:osfamily] == 'RedHat'
          is_expected.to contain_exec('reload-sshd')
            .with(
              'command'     => 'service sshd reload',
              'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'refreshonly' => true,
            )
        else
          is_expected.to contain_exec('reload-sshd')
            .with(
              'command'     => 'systemctl reload sshd',
              'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'refreshonly' => true,
            )
        end

        is_expected.to contain_exec('reload-rsyslogd')
          .with(
            'command'     => 'pkill -HUP rsyslogd',
            'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            'refreshonly' => true,
          )

        is_expected.to contain_exec('reload-rsyslog')
          .with(
            'command'     => 'pkill -HUP rsyslog',
            'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            'refreshonly' => true,
          )

        is_expected.to contain_exec('reload-syslog-ng')
          .with(
            'command'     => 'pkill -HUP syslog-ng',
            'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            'refreshonly' => true,
          )

        is_expected.to contain_exec('authselect-apply-changes')
          .with(
            'command'     => 'authselect apply-changes',
            'path'        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            'refreshonly' => true,
          )
      }
    end
  end
end
