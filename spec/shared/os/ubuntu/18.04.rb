shared_examples 'os::ubuntu::18.04' do
  puts 'Ubuntu 18.04 tests'
  include_examples 'common::1.1.1.1'
  include_examples 'common::1.1.1.2'
  include_examples 'common::1.1.1.3'
  include_examples 'common::1.1.1.4'
  include_examples 'common::1.1.1.5'
end
