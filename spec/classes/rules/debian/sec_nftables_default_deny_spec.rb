require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::debian::sec_nftables_default_deny' do
  enforce_options.each do |enforce|
    context "Debian with enforce #{enforce}" do
      let(:pre_condition) do
        <<-EOF
        exec { 'dump nftables ruleset':
          command     => 'nft list ruleset > /etc/nftables/nftables.rules',
          path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
          refreshonly => true,
        }
        EOF
      end
      let(:facts) do
        {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          architecture: 'x86_64',
          'security_baseline' => {
            'nftables' => {
              'base_chain_input' => 'none',
              'base_chain_forward' => 'none',
              'base_chain_output' => 'none',
              'base_chain_status' => false,
              'table_count' => 0,
              'table_count_status' => false,
              'conns' => {
                'status' => false,
                'in_tcp' => false,
                'in_udp' => false,
                'in_icmp' => false,
                'out_tcp' => false,
                'out_udp' => false,
                'out_icmp' => false,
              },
              'inet' => {
                'policy' => {
                  'input' => 'accept',
                  'output' => 'accept',
                  'forward' => 'accept',
                  'status' => false,
                },
              },
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'nftables default deny',
          'log_level' => 'warning',
          'default_policy_input' => 'drop',
          'default_policy_forward' => 'drop',
          'default_policy_output' => 'drop',
          'table' => 'inet',
          'additional_rules' => {
            'input' => ['tcp dport ssh accept'],
          },
        }
      end

      it {
        is_expected.to compile
        if enforce
          is_expected.to contain_exec('set input default policy')
            .with(
              'command' => 'nft chain inet filter input { policy drop \; }',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            )
            .that_notifies('Exec[dump nftables ruleset]')

          is_expected.to contain_exec('set forward default policy')
            .with(
              'command' => 'nft chain inet filter forward { policy drop \; }',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            )
            .that_notifies('Exec[dump nftables ruleset]')

          is_expected.to contain_exec('set output default policy')
            .with(
              'command' => 'nft chain inet filter output { policy drop \; }',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            )
            .that_notifies('Exec[dump nftables ruleset]')

          is_expected.to contain_exec('adding rule tcp dport ssh accept')
            .with(
              'command' => 'nft add rule inet filter input tcp dport ssh accept',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
              'onlyif'  => 'test -z "$(nft list ruleset inet | grep \'tcp dport ssh accept\')"',
            )
            .that_notifies('Exec[dump nftables ruleset]')

          is_expected.not_to contain_echo('nftables-default-deny')
        else
          is_expected.not_to contain_exec('set input default policy')
          is_expected.not_to contain_exec('set forward default policy')
          is_expected.not_to contain_exec('set output default policy')
          is_expected.not_to contain_exec('adding rule tcp dport ssh accept')
          is_expected.to contain_echo('nftables-default-deny')
            .with(
              'message'  => 'nftables default deny',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      }
    end
  end
end
