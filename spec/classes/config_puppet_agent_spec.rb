require 'spec_helper'

describe 'security_baseline::config_puppet_agent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      os_facts.merge(
        'security_baseline' => {
          'puppet_agent_postrun' => '',
        },
      )

      it { is_expected.to compile }
    end
  end
end