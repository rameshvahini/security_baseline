require 'spec_helper'

describe 'security_baseline::rules::sec_vfat' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'enforce' => true,
          'message' => 'vfat',
          'loglevel' => 'warning',
        }
      end

      it { is_expected.to compile }
    end
  end
end
