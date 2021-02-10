plan piper::gradle_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {

	if $facts['osfamily'] != 'windows' {
 	  package { 'curl':
    	    ensure => present,
  	  }	

          package { 'unzip':
            ensure => present,
          }

          Archive {
            provider => 'curl',
    	    require  => Package['curl', 'unzip'],
         } 
        }
        
       	$dirname = 'gradle-5.6.3'
	$filename = "${dirname}-bin.zip"
	$install_path = "/opt/${dirname}"
	$gradleProfile =  @(EOT) 
		export GRADLE_HOME=/opt/gradle 
		export PATH=${GRADLE_HOME}/bin:${PATH}
		|-EOT


	archive { $filename:
 	 path          => "/tmp/${filename}",
	 source        => "https://services.gradle.org/distributions/${filename}",
         extract       => true,
         extract_path  => '/opt',
         creates       => $install_path,
         cleanup       => true
        } 
	file { '/opt/gradle':
  		ensure => link,
  		target => "/opt/${dirname}",
	}
	file { '/etc/profile.d/gradle.sh':
	    content => $gradleProfile,
	    mode => '+x'
	}	
     }
} 
