require 'spec_helper'

describe 'security_baseline::rules::redhat::sec_selinux_bootloader' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'bootloader_selinux' => false,
        )
      end
      let(:params) do
        {
          'enforce' => true,
          'message' => 'selinux bootloader',
          'loglevel' => 'warning',
        }
      end

      it { is_expected.to compile }
    end
  end
end
