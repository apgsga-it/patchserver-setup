plan piper::jenkins_dirs_create (
  TargetSpec $targets,
  String $user
) {
  $targets.apply_prep
  $timestamp = Timestamp.new().strftime('gradlehome%Y%m%d%H%M%S')
  $temp_dir = "/tmp/${$timestamp}"
  $targetall = get_targets('all')[0]
  $jenkins_user = "jenkins"
  # Sudu User's public rsa key on target
  $dl_user_result = download_file("/home/${user}/.ssh/id_rsa.pub", 'user', $targets)
  $user_rsa_target = file::read($dl_user_result.first['path'])
  # User public rsa key on target on Host
  # TODO (che, 19.11) is this disireable of production target
  $home_dir = system::env('HOME')
  $user_rsa_local = file::read("${$home_dir}/.ssh/id_rsa.pub")
  $maven_profile_default = $targetall.vars[maven_profile_base] # TODO (che, jhe 17.2) :Is this correct as default
  if $targetall.facts[environment] == "development"{
      $maven_profile = "${maven_profile_default}-${user}"
  } elsif $targetall.facts[environment] == "integration" {
    $maven_profile = "${maven_profile_default}-test" # TODO (che, jhe 17.2) : What profile for Integration?
  } else {
     $maven_profile = "${maven_profile_default}"
  }
  apply($targets) {
    # apg-patch-service-server user on target
    $patch_rsa_target = file::read("${targetall.vars[hiera_data_repo_path]}/environment/${targetall.facts[environment]}/${lookup('piper::ssh::path::public')}")
    $ssh_keys = "${user_rsa_target}\n${user_rsa_local}"
    file { $temp_dir:
      ensure => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0777',
    }
    file { $home_dir/apg-script:
      ensure => directory,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0777',
    }
    file { $home_dir/apg-script/branchWorkaround.sh:
      ensure => file,
      content => epp('piper/branchWorkaround.sh.epp', { }),      
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0640',
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
      content => epp('piper/jenkins.yaml.epp', { 'jenkinsuser' => "${user}" , 'authorized_keys' => $ssh_keys ,  'piper_authorized_keys' => $patch_rsa_target ,  'maven_profile' => $maven_profile}),
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
  upload_file('/tmp/patchserver-setup/gradlehome' ,"${temp_dir}", $targets,  '_catch_errors' => false,'_run_as' => 'root' )
  run_command("rsync -P -r --ignore-existing --include=*/ --exclude=.git* ${temp_dir}/gradlehome/* ${targetall.vars[gradle_home]}/home", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chmod u+x ${targetall.vars[gradle_home]}/home/initGradleProfile.sh", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("cd ${targetall.vars[gradle_home]}/home ; ./initGradleProfile.sh  /home/jenkins/.m2 ${maven_profile} ${targetall.vars[maven_home]} copySettingsXml", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chown -R ${jenkins_user}:${jenkins_user} ${targetall.vars[gradle_home]}/home", $targets, '_catch_errors' => true, '_run_as' => 'root')


}
