require 'facter/helpers/check_service_enabled'
require 'facter/helpers/check_package_installed'
require 'facter/helpers/check_kernel_module'
require 'facter/helpers/get_duplicate_groups'
require 'facter/helpers/get_duplicate_users'
require 'facter/helpers/get_sysctl_value'
require 'facter/helpers/get_facts_kernel_modules'
require 'facter/helpers/get_facts_packages_installed'
require 'facter/helpers/get_facts_services_enabled'
require 'facter/helpers/get_facts_xinetd_services'
require 'facter/helpers/get_facts_sysctl'
require 'facter/helpers/get_facts_aide'
require 'facter/helpers/check_value_string'
require 'facter/helpers/check_value_boolean'
require 'facter/helpers/check_value_regex'
require 'facter/helpers/read_file_stats'

# frozen_string_literal: true

# security_baseline.rb
# collect facts about the security baseline

Facter.add(:security_baseline) do
  confine osfamily: ['RedHat', 'Suse']
  setcode do
    distid = Facter.value(:lsbdistid)
    security_baseline = {}

    val = Facter::Core::Execution.exec('puppet config print | grep postrun_command')
    security_baseline['puppet_agent_postrun'] = if val.empty? || val.nil?
                                                  'none'
                                                else
                                                  val
                                                end

    security_baseline[:kernel_modules] = get_facts_kernel_modules
    security_baseline[:packages_installed] = get_facts_packages_installed
    security_baseline[:services_enabled] = get_facts_services_enabled
    security_baseline[:xinetd_services] = get_facts_xinetd_services
    security_baseline[:sysctl] = get_facts_sysctl
    security_baseline[:aide] = get_facts_aide(distid)

    selinux = {}
    val = Facter::Core::Execution.exec('grep "^\s*linux" /boot/grub2/grub.cfg | grep -e "selinux.*=.*0" -e "enforcing.*=.*0"')
    selinux['bootloader'] = check_value_boolean(val, true)
    security_baseline[:selinux] = selinux

    partitions = {}
    shm = {}
    mounted = Facter::Core::Execution.exec('mount | grep /dev/shm')
    shm['nodev'] = check_value_regex(mounted, 'nodev')
    shm['noexec'] = check_value_regex(mounted, 'noexec')
    shm['nosuid'] = check_value_regex(mounted, 'nosuid')
    shm['partition'] = Facter::Core::Execution.exec('mount | grep /dev/shm')
    partitions['shm'] = shm

    home = {}
    home['partition'] = Facter::Core::Execution.exec('mount | grep /home')
    mounted = Facter::Core::Execution.exec('mount | grep /home')
    home['nodev'] = check_value_regex(mounted, 'nodev')
    partitions['home'] = home

    tmp = {}
    tmp['partition'] = Facter::Core::Execution.exec('mount | grep "/tmp "')
    mounted = Facter::Core::Execution.exec('mount | grep /tmp')
    tmp['nodev'] = check_value_regex(mounted, 'nodev')
    tmp['noexec'] = check_value_regex(mounted, 'noexec')
    tmp['nosuid'] = check_value_regex(mounted, 'nosuid')
    partitions['tmp'] = tmp

    var_tmp = {}
    var_tmp['partition'] = Facter::Core::Execution.exec('mount | grep "/var/tmp "')
    mounted = Facter::Core::Execution.exec('mount | grep /var/tmp')
    var_tmp['nodev'] = check_value_regex(mounted, 'nodev')
    var_tmp['noexec'] = check_value_regex(mounted, 'noexec')
    var_tmp['nosuid'] = check_value_regex(mounted, 'nosuid')
    partitions['var_tmp'] = var_tmp

    var = {}
    var['partition'] = Facter::Core::Execution.exec('mount | grep "/var "')
    partitions['var'] = var

    var_log = {}
    var_log['partition'] = Facter::Core::Execution.exec('mount | grep "/var/log "')
    partitions['var_log'] = var_log

    var_log_audit = {}
    var_log_audit['partition'] = Facter::Core::Execution.exec('mount | grep "/var/log/audit "')
    partitions['var_log_audit'] = var_log_audit

    security_baseline[:partitions] = partitions

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      yum = {}
      yum['repolist'] = Facter::Core::Execution.exec('yum repolist')
      value = Facter::Core::Execution.exec('grep ^gpgcheck /etc/yum.conf')
      yum['gpgcheck'] = if value.empty?
                          false
                        elsif value == 'gpgcheck=1'
                          true
                        else
                          false
                        end
      security_baseline[:yum] = yum
    end

    groups = {}
    groups['duplicate_gid'] = get_duplicate_groups('gid')
    groups['duplicate_group'] = get_duplicate_groups('group')
    security_baseline[:groups] = groups

    users = {}
    users['duplicate_uid'] = get_duplicate_users('uid')
    users['duplidate_user'] = get_duplicate_users('user')
    security_baseline[:users] = users

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      x11 = {}
      pkgs = Facter::Core::Execution.exec('rpm -qa xorg-x11*')
      x11['installed'] = pkgs.split("\n")

      security_baseline[:x11] = x11
    end

    single_user_mode = {}

    resc = Facter::Core::Execution.exec('grep /sbin/sulogin /usr/lib/systemd/system/rescue.service')
    single_user_mode['rescue'] = check_value_boolean(resc, false)

    emerg = Facter::Core::Execution.exec('grep /sbin/sulogin /usr/lib/systemd/system/emergency.service')
    single_user_mode['emergency'] = check_value_boolean(emerg, false)

    single_user_mode['status'] = if (single_user_mode['emergency'] == false) || (single_user_mode['rescue'] == false)
                                   false
                                 else
                                   true
                                 end
    security_baseline[:single_user_mode] = single_user_mode

    issue = {}
    issue['os'] = read_file_stats('/etc/issue')
    issue['os']['content'] = Facter::Core::Execution.exec('egrep \'(\\\v|\\\r|\\\m|\\\s)\' /etc/issue')
    issue['net'] = read_file_stats('/etc/issue.net')
    issue['net']['content'] = Facter::Core::Execution.exec('egrep \'(\\\v|\\\r|\\\m|\\\s)\' /etc/issue.net')
    security_baseline[:issue] = issue

    motd = {}
    motd['content'] = Facter::Core::Execution.exec("egrep '(\\\\v|\\\\r|\\\\m|\\\\s)' /etc/motd")
    val = read_file_stats('/etc/motd')
    motd['uid'] = val['uid']
    motd['gid'] = val['gid']
    motd['mode'] = val['mode']
    security_baseline[:motd] = motd

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      security_baseline[:rpm_gpg_keys] = Facter::Core::Execution.exec("rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'")
      val = Facter::Core::Execution.exec("ps -eZ | egrep \"initrc\" | egrep -vw \"tr|ps|egrep|bash|awk\" | tr ':' ' ' | awk '{ print $NF }'")
      security_baseline[:unconfigured_daemons] = check_value_string(val, 'none')
    end

    val = Facter::Core::Execution.exec("df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null")
    security_baseline[:sticky_ww] = check_value_string(val, 'none')

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      val = Facter::Core::Execution.exec('yum check-update --security -q | grep -v ^$')
      security_baseline[:security_patches] = check_value_string(val, 'none')
    end

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      security_baseline[:gnome_gdm] = Facter::Core::Execution.exec('rpm -qa | grep gnome') != ''
    end

    grub = {}
    val = Facter::Core::Execution.exec('grep "^GRUB2_PASSWORD" /boot/grub2/grub.cfg')
    grub['grub_passwd'] = check_value_boolean(val, false)
    grub['grub.cfg'] = read_file_stats('/boot/grub2/grub.cfg')
    grub['user.cfg'] = read_file_stats('/boot/grub2/user.cfg')
    security_baseline[:grub] = grub

    tcp_wrapper = {}
    tcp_wrapper['host_allow'] = File.exist?('/etc/hosts.allow')
    tcp_wrapper['host_deny'] = File.exist?('/etc/hosts.deny')
    security_baseline[:tcp_wrapper] = tcp_wrapper

    coredumps = {}
    fsdumpable = if security_baseline.key?('sysctl')
                   if security_baseline['sysctl'].key?('fs_dumpable')
                     security_baseline['sysctl']['fs_dumpable']
                   else
                     nil
                   end
                 else
                   nil
                 end

    coredumps['limits'] = Facter::Core::Execution.exec('grep "hard core" /etc/security/limits.conf /etc/security/limits.d/*')
    coredumps['status'] = if coredumps['limits'].empty? || (!fsdumpable.nil? && (security_baseline['sysctl']['fs_dumpable'] != 0))
                            false
                          else
                            true
                          end

    security_baseline[:coredumps] = coredumps

    if distid =~ %r{RedHatEnterprise|CentOS|Fedora}
      pkgs = Facter::Core::Execution.exec('rpm -qa xorg-x11*')
      security_baseline['x11-packages'] = pkgs.split("\n")
    end

    cron = {}
    cron['/etc/crontab'] = read_file_stats('/etc/crontab')
    cron['/etc/cron.hourly'] = read_file_stats('/etc/cron.hourly')
    cron['/etc/cron.daily'] = read_file_stats('/etc/cron.daily')
    cron['/etc/cron.weekly'] = read_file_stats('/etc/cron.weekly')
    cron['/etc</cron.monthly'] = read_file_stats('/etc/cron.monthly')
    cron['/etc/cron.d'] = read_file_stats('/etc/cron.d')
    cron['/etc/cron.allow'] = read_file_stats('/etc/cron.allow')
    cron['/etc/cron.deny'] = read_file_stats('/etc/cron.deny')
    cron['/etc/at.allow'] = read_file_stats('/etc/at.allow')
    cron['/etc/at.deny'] = read_file_stats('/etc/at.deny')

    cron['restrict'] = if (cron['/etc/cron.allow']['uid'] != 0) ||
                          (cron['/etc/cron.allow']['gid'] != 0) ||
                          (cron['/etc/cron.allow']['mode'] != 0o0600) ||
                          (cron['/etc/cron.deny']['uid'] != 0) ||
                          (cron['/etc/cron.deny']['gid'] != 0) ||
                          (cron['/etc/cron.deny']['mode'] != 0o0600) ||
                          (cron['/etc/at.allow']['uid'] != 0) ||
                          (cron['/etc/at.allow']['gid'] != 0) ||
                          (cron['/etc/at.allow']['mode'] != 0o0600) ||
                          (cron['/etc/at.deny']['uid'] != 0) ||
                          (cron['/etc/at.deny']['gid'] != 0) ||
                          (cron['/etc/at.deny']['mode'] != 0o0600)
                         false
                       else
                         true
                       end

    security_baseline['cron'] = cron

    sshd = {}
    sshd['/etc/ssh/sshd_config'] = read_file_stats('/etc/ssh/sshd_config')

    val = Facter::Core::Execution.exec('grep "^Protocol" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['protocol'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^LogLevel" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['loglevel'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^X11Forwarding" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['x11forwading'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^MaxAuthTries" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['maxauthtries'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^IgnoreRhosts" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['ignorerhosts'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^HostbasedAuthentication" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['hostbasedauthentication'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^PermitRootLogin" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['permitrootlogin'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^PermitEmptyPasswords" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['permitemptypasswords'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^PermitUserEnvironment" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['permituserenvironment'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^MACs" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip.split(%r{\,})
    sshd['macs'] = val
    val = Facter::Core::Execution.exec('grep "^ClientAliveInterval" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['clientaliveinterval'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^ClientAliveCountMax" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['vlientalivecountmax'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^LoginGraceTime" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['logingracetime'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^AllowUsers" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['allowusers'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^AllowGroups" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['allowgroups'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^DenyUsers" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['denyusers'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^DenyGroups" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['denygroups'] = check_value_string(val, 'none')
    val = Facter::Core::Execution.exec('grep "^Banner" /etc/ssh/sshd_config | awk \'{print $2;}\'').strip
    sshd['banner'] = check_value_string(val, 'none')
    security_baseline['sshd'] = sshd

    security_baseline
  end
end
