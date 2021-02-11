plan piper::gradle_cred_setup (
     TargetSpec $targets
   ) {
     $targets.apply_prep
		 $targetall = get_targets('all')[0]
     apply($targets) {
				$gradleBuild =  @(EOT)
					plugins {
						id "nu.studer.credentials" version "2.1"
					}
					|-EOT
		    $jenkins_user = 'jenkins'
		 		$timestamp = Timestamp.new().strftime('gradleproject%Y%m%d%H%M%S')
		 		$temp_dir = "/tmp/${$timestamp}"
		 		file { $temp_dir:
		 				ensure => directory,
						owner => $jenkins_user,
						group => $jenkins_user,
						mode => '700',
				}
				file { "${temp_dir}/build.gradle":
					ensure => file,
					content => $gradleBuild,
					owner => $jenkins_user,
					group => $jenkins_user,
					mode => '0700',
				}
				file { "${temp_dir}/settings.gradle":
					ensure => file,
					content => "",
					owner => $jenkins_user,
					group => $jenkins_user,
					mode => '0700',
				}
				exec { "gradle addCredentials --key ${targetall.vars[install_ssh_user_key]} --value ${targetall.vars[install_ssh_user]} -Dgradle.user.home=${targetall.vars[gradle_home]}/home --stacktrace --info":
					cwd     => $temp_dir,
					path     => ['/opt/gradle/bin', '/usr/bin'],
					user    => $jenkins_user,
					group   => $jenkins_user,
				}
				exec { "gradle addCredentials --key ${targetall.vars[install_ssh_pw_key]} --value ${targetall.vars[install_ssh_pw]} -Dgradle.user.home=${targetall.vars[gradle_home]}/home --stacktrace --info":
					cwd     => $temp_dir,
					path     => ['/opt/gradle/bin', '/usr/bin'],
					user    => $jenkins_user,
					group   => $jenkins_user,
				}
     }
} 
