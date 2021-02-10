plan piper::accounts_sshkeys (
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  $jenkins_user = "jenkins"
  $jenkins_ssh_dir = "/home/${jenkins_user}/.ssh"
  $piper_user = "apg-patch-service-server"
  $piper_ssh_dir = "/home/${piper_user}/.ssh"
  $jenkins_public = "${jenkins_ssh_dir}/id_rsa.pub"
  $jenkins_private = "${jenkins_ssh_dir}/id_rsa"
  $piper_public = "${piper_ssh_dir}/id_rsa.pub"
  $piper_private = "${piper_ssh_dir}/id_rsa"
  $r1 = apply($targets) {
      file { $jenkins_ssh_dir:
        ensure => directory,
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '700',
      }
      file { $piper_ssh_dir:
        ensure => directory,
        owner => $piper_user,
        group => $piper_user,
        mode => '700',
      }
      file { $jenkins_public:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/${lookup('jenkins::ssh::path::public')}"),
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0644',
      }
      file { $jenkins_private:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/${lookup('jenkins::ssh::path::private')}"),
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0600',
      }
      file { $piper_public:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/${lookup('piper::ssh::path::public')}"),
        owner => $piper_user,
        group => $piper_user,
        mode => '0644',
      }
      file { $piper_private:
        ensure => file,
        content => file::read("${targetall.vars[hiera_data_repo_path]}/${lookup('piper::ssh::path::private')}"),
        owner => $piper_user,
        group => $piper_user,
        mode => '0600',
      }
    }

}

