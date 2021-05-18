plan piper::maven_install(
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
    $dirname = 'apache-maven-3.8.1'
    $filename = "${dirname}-bin.zip"
    $mirror = 'https://downloads.apache.org/maven/maven-3/3.8.1/binaries/'
    $install_path = "/opt/${dirname}"
    $profile = @(EOT)
            export MAVEN_HOME=/opt/maven
            export PATH=${MAVEN_HOME}/bin:${PATH}
            |-EOT
    archive { $filename:
      path         => "/tmp/${filename}",
      source       => "$mirror/${filename}",
      extract      => true,
      extract_path => '/opt',
      creates      => $install_path,
      cleanup      => true
    }
    file { '/opt/maven':
      ensure => link,
      target => "/opt/${dirname}",
    }
    file { '/etc/profile.d/maven.sh':
      content => $profile,
      mode    => '+x'
    }
  }
} 
