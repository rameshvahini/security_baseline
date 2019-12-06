require 'spec_helper'

describe 'security_baseline::rules::common::sec_var_log_audit_partition' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'unconfigured_daemons' => true,
        )
      end
      let(:params) do
        {
          'enforce' => true,
          'message' => 'var_log_audit_partition',
          'loglevel' => 'warning',
        }
      end

      it { is_expected.to compile }
    end
  end
end