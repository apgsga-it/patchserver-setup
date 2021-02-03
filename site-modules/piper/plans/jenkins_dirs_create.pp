plan piper::jenkins_dirs_create (
  TargetSpec $targets,
  String $user
) {
  $targets.apply_prep
  $piper_user = "apg-patch-service-server"
  $piper_home_dir = "/home/${piper_user}"
  $piper_ssh_dir = "${piper_home_dir}/.ssh"
  apply($targets) {
  # TODO (che, 19.11) hmmm, this should'nt be necessary? But the download , see below croaks
    file { $piper_home_dir:
      ensure => directory,
      mode   => '0755',
    }
    file { $piper_ssh_dir:
      ensure => directory,
      mode   => '0755',
    }
  }
  $timestamp = Timestamp.new().strftime('gradlehome%Y%m%d%H%M%S')
  $temp_dir = "/tmp/${$timestamp}"
  $targetall = get_targets('all')[0]
  $jenkins_user = "jenkins"
  # Sudu User's public rsa key on target
  $dl_user_result = download_file("/home/${user}/.ssh/id_rsa.pub", 'user', $targets)
  $user_rsa_target = file::read($dl_user_result.first['path'])
  # apg-patch-service-server user on target
  $dl_patch_result = download_file("${piper_ssh_dir}/id_rsa.pub", 'piper', $targets)
  $patch_rsa_target = file::read($dl_patch_result.first['path'])
  # User public rsa key on target on Host
  # TODO (che, 19.11) is this disireable of production target
  $home_dir = system::env('HOME')
  $user_rsa_local = file::read("${$home_dir}/.ssh/id_rsa.pub")
  $ssh_keys = "${user_rsa_target}\n${user_rsa_local}\n${patch_rsa_target}"
  apply($targets) {
    file { $temp_dir:
      ensure => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0777',
    }
    file { '/etc/jenkins':
       ensure => directory,
       owner => $jenkins_user,
       group => $jenkins_user,
       mode => '0644',
    }
    file { '/etc/jenkins/casc':
        ensure => directory,
        owner => $jenkins_user,
        group => $jenkins_user,
        mode => '0644',
    }
    file { '/etc/jenkins/casc/jenkins.yaml':
      ensure  => file,
      content => epp('piper/jenkins.yaml.epp', { 'jenkinsuser' => "${user}" , 'authorized_keys' => $ssh_keys }),
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0644',
    }
    file { '/var/jenkins':
      ensure  => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0644',
    }
    file { $targetall.vars[gradle_home]:
      ensure  => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0777',
    }
    file { $targetall.vars[maven_home]:
      ensure  => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0777',
    }
  }

  ## Jenkins Gradle and Maven Home Setup
  upload_file('/tmp/gradlehome' ,"${temp_dir}", $targets,  '_catch_errors' => false,'_run_as' => 'root' )
  run_command("rsync -P -r --ignore-existing --include=*/ --exclude=.git* ${temp_dir}/gradlehome/* ${targetall.vars[gradle_home]}/home", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chmod u+x ${targetall.vars[gradle_home]}/home/initGradleProfile.sh", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("cd ${targetall.vars[gradle_home]}/home ; ./initGradleProfile.sh  /home/jenkins/.m2 ${targetall.vars[maven_profile]} ${targetall.vars[maven_home]} copySettingsXml", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chown -R ${jenkins_user}:${jenkins_user} ${targetall.vars[gradle_home]}/home", $targets, '_catch_errors' => true, '_run_as' => 'root')


}
