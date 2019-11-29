require 'spec_helper'

describe 'security_baseline::rules::redhat::sec_users_netrc_files_write' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
