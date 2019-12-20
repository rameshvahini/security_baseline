require 'spec_helper'

enforce_options = [true, false]

describe 'security_baseline::rules::redhat::sec_nftables_table' do
  enforce_options.each do |enforce|
    context "RedHat with enforce #{enforce}" do
      let(:facts) do
        {
          osfamily: 'RedHat',
          operatingsystem: 'CentOS',
          architecture: 'x86_64',
          'security_baseline' => {
            'nftables' => {
              'table_count' => 0,
              'table_count_status' => false,
            },
          },
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
          'message' => 'nft tables',
          'log_level' => 'warning',
          'nftables_default_table' => 'test',
        }
      end

      it {
        is_expected.to compile
        if enforce
          is_expected.to contain_exec('create nfs table test')
            .with(
              'command' => 'nft create table inet test',
              'path'    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            )

          is_expected.not_to contain_echo('nftables-table')
        else
          is_expected.not_to contain_exec('create nfs table test')
          is_expected.to contain_echo('nftables-table')
            .with(
              'message'  => 'nft tables',
              'loglevel' => 'warning',
              'withpath' => false,
            )
        end
      }
    end
  end
end
