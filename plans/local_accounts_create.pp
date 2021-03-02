plan piper::local_accounts_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  $r1 = apply($targets) {
      # Eager variables , for later processing
      $jenkins_user = "${lookup('jenkins::target::user')}"
      $jenkins_ssh_dir = "/home/${jenkins_user}/.ssh"
      $piper_user = "${lookup('piper::service::target::user')}"
      $piper_ssh_dir = "/home/${piper_user}/.ssh"
      $jenkins_public = "${jenkins_ssh_dir}/id_rsa.pub"
      $jenkins_private = "${jenkins_ssh_dir}/id_rsa"
      $piper_public = "${piper_ssh_dir}/id_rsa.pub"
      $piper_private = "${piper_ssh_dir}/id_rsa"
      # Jenkins User und directories
      accounts::user { $jenkins_user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => " ${user} User added with patchserver-setup",
        password => Sensitive("${lookup('jenkins::target::pw')}"),
      }
      file { "/home/${jenkins_user}/.m2":
        ensure => directory,
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0644',
      }
      # Piper User and ssh config
      accounts::user { $piper_user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => "${piper_user} User added with patchserver-setup",
        password => Sensitive("${lookup('piper::service::target::pw')}"),
      }
      ssh::config_entry { $piper_user:
        host  => '*',
        ensure => present,
        path   => "${piper_ssh_dir}/config",
        owner  => $piper_user,
        group  => $piper_user,
        lines => [
          '  NoHostAuthenticationForLocalhost yes',
        ],
      }
      # Private and Public RSA Key for Jenkins and Piper
      file { $jenkins_public:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/environment/${targetall.facts[environment]}/${lookup('jenkins::ssh::path::public')}"),
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0644',
      }
      file { $jenkins_private:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/environment/${targetall.facts[environment]}/${lookup('jenkins::ssh::path::private')}"),
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0600',
      }
      file { $piper_public:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/environment/${targetall.facts[environment]}/${lookup('piper::ssh::path::public')}"),
        owner => $piper_user,
        group => $piper_user,
        mode => '0644',
      }
      file { $piper_private:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/environment/${targetall.facts[environment]}/${lookup('piper::ssh::path::private')}"),
        owner => $piper_user,
        group => $piper_user,
        mode => '0600',
      }
  }
}
