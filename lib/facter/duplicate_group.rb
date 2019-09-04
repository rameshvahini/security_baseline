# frozen_string_literal: true

# duplicate_group.rb
# Ensures there are no duplicate Groiups in /etc/group
Facter.add('duplicate_group') do
  confine kernel: 'Linux'
  setcode do
    groups = ''
    if File.exist?('/etc/group')
      groupdata = {}
      lines = File.open('/etc/group').readlines
      lines.each do |line|
        next if line =~ %r{^#}
        data = line.split(%r{:})
        group = data[0]
        gid = data[2]
        if groupdata.key?(group)
          groupdata[gid][:cnt] = groupdata[group]['cnt'] + 1
          groupdata[gid][:gid] = "#{groupdata[group][:gid]};#{gid}"
        else
          groupdata[group] = { cnt: 1, gid: gid }
        end
      end

      groupdata.each do |group, value|
        if value[:cnt] > 1
          groups = "Duplicate group #{group} Gids: #{value[:gid]}"
        end
      end
    end

    groups
  end
end
