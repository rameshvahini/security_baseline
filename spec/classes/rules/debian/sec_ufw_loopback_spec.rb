require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::debian::sec_ufw_loopback' do
  enforce_options.each do |enforce|
    context "on Debian with enforce = #{enforce}" do
      let(:facts) do
        {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          architecture: 'x86_64',
          security_baseline: {
            services_enabled: {
              srv_ufw: 'disabled',
            },
            ufw: {
              loopback_status: false,
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'ufw loopback',
          'log_level' => 'warning',
        }
      end

      it { is_expected.to compile }
      it do
        if enforce
          is_expected.to contain_exec('add allow on lo')
            .with(
              'command' => 'ufw allow in on lo',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'onlyif'  => 'test -z "$(ufw status verbose | grep -E \"^Anywhere.*on lo.*ALLOW IN.*Anywhere\")""',
            )

          is_expected.to contain_exec('add deny on 127.0.0.0/8')
            .with(
              'command' => 'ufw deny in from 127.0.0.0/8',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'onlyif'  => 'test -z "$(ufw status verbose | grep -E \"^Anywhere.*DENY IN.*127.0.0.0/8\")""',
            )

          is_expected.to contain_exec('add deny on ::1')
            .with(
              'command' => 'ufw deny in from ::1',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'onlyif'  => 'test -z "$(ufw status verbose | grep -E \"^Anywhere (v6).*DENY IN.*::1\")""',
            )

          is_expected.not_to contain_echo('ufw-loopback')
        else
          is_expected.not_to contain_exec('add allow on lo')
          is_expected.not_to contain_exec('add deny on 127.0.0.0/8')
          is_expected.not_to contain_exec('add deny on ::1')
          is_expected.to contain_echo('ufw-loopback')
            .with(
              'message'  => 'ufw loopback',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      end
    end
  end
end
