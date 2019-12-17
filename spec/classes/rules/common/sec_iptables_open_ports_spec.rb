require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::common::sec_iptables_open_ports' do
  on_supported_os.each do |os, os_facts|
    enforce_options.each do |enforce|
      context "on #{os}" do
        let(:facts) do
          os_facts.merge(
            'security_baseline' => {
              'iptables' => {
                'policy' => {
                  'rule 1' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => 'lo',
                    'info' => '/* 001 accept all incoming traffic to local interface */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'all',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => '',
                    'target' => 'ACCEPT',
                  },
                  'rule 10' => {
                    'chain' => 'OUTPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'state NEW,ESTABLISHED /* 006 accept outbound icmp state new, established */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'icmp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW,ESTABLISHED',
                    'target' => 'ACCEPT',
                  },
                  'rule 11' => {
                    'chain' => 'OUTPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'multiport dports 53 state NEW /* 103 dns udp outbound */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'udp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW',
                    'target' => 'ACCEPT',
                  },
                  'rule 12' => {
                    'chain' => 'OUTPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'multiport dports 53 state NEW /* 104 dns tcp inbound */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'tcp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW',
                    'target' => 'ACCEPT',
                  },
                  'rule 2' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => '/* 003 drop all traffic to lo 127.0.0.1/8 */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'all',
                    'spt' => '',
                    'src' => '127.0.0.0/8',
                    'state' => '',
                    'target' => 'DROP',
                  },
                  'rule 3' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'state ESTABLISHED /* 008 accept inbound udp state established */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'udp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'ESTABLISHED',
                    'target' => 'DROP',
                  },
                  'rule 4' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'state ESTABLISHED /* 009 accept inbound icmp state established */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'icmp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'ESTABLISHED',
                    'target' => 'ACCEPT',
                  },
                  'rule 5' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'multiport dports 22 state NEW /* 100 ssh inbound */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'tcp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW',
                    'target' => 'DROP',
                  },
                  'rule 6' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'multiport dports 443 state NEW /* 101 httpd inbound */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'tcp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW',
                    'target' => 'ACCEPT',
                  },
                  'rule 7' => {
                    'chain' => 'INPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'multiport dports 53 state NEW /* 102 dns udp inbound */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'udp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW',
                    'target' => 'ACCEPT',
                  },
                  'rule 8' => {
                    'chain' => 'OUTPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => '/* 002 accept all outgoing traffic to local interface */',
                    'opts' => '--',
                    'out' => 'lo',
                    'proto' => 'all',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => '',
                    'target' => 'ACCEPT',
                  },
                  'rule 9' => {
                    'chain' => 'OUTPUT',
                    'dpt' => '',
                    'dst' => '0.0.0.0/0',
                    'icmptype' => '',
                    'in' => '*',
                    'info' => 'state NEW,ESTABLISHED /* 005 accept outbound udp state new, established */',
                    'opts' => '--',
                    'out' => '*',
                    'proto' => 'udp',
                    'spt' => '',
                    'src' => '0.0.0.0/0',
                    'state' => 'NEW,ESTABLISHED',
                    'target' => 'ACCEPT',
                  },
                },
                'policy_status' => false,
              },
            },
          )
        end
        let(:params) do
          {
            'enforce' => enforce,
            'message' => 'iptables port policies',
            'log_level' => 'warning',
            'firewall_rules' => {
              '100 ssh inbound' => {
                'chain' => 'INPUT',
                'proto' => 'tcp',
                'dport' => 22,
                'state' => 'NEW',
                'action' => 'accept',
              },
            },
          }
        end

        it {
          is_expected.to compile

          if enforce
            is_expected.to contain_firewall('100 ssh inbound')
              .with(
                'chain'  => 'INPUT',
                'proto'  => 'tcp',
                'dport'  => 22,
                'state'  => 'NEW',
                'action' => 'accept',
              )

            is_expected.not_to contain_echo('iptables-open-ports')
          else
            is_expected.not_to contain_firewall('100 ssh inbound')
            is_expected.to contain_echo('iptables-open-ports')
              .with(
                'message'  => 'iptables port policies',
                'loglevel' => 'warning',
                'withpath' => false,
              )
          end
        }
      end
    end
  end
end
