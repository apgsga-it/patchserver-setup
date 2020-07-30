plan piper::apg_yum_repo (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
          class { 'yum':
              repos => {
                  'Apg-Piper-Yum' => { ensure => 'present',
                      enabled =>  true,
                      gpgcheck => false,
                      descr => 'Apg Piper Repo',
                      baseurl => "https://${lookup('yum::user:name')}:${lookup('yum::user:pw')}@artifactory4t4apgsga.jfrog.io/artifactory4t4apgsga/multiservice_yumdev",
                      target => '/etc/yum.repos.d/Apg-Piper-Yum.repo'},
              },
              managed_repos => ['Apg-Piper-Yum'],
          }
    }

}
