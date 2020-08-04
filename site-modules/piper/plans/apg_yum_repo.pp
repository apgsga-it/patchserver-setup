plan piper::apg_yum_repo (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     $targetall = get_targets('all')[0]
     apply($targets) {
          class { 'yum':
              repos => {
                  'Apg-Piper-Yum' => { ensure => 'present',
                      enabled =>  true,
                      gpgcheck => false,
                      descr => 'Apg Piper Repo',
                      baseurl => "https://${lookup('yum::user:name')}:${lookup('yum::user:pw')}@${artifactory_uri}/${yum_repo}",
                      target => '/etc/yum.repos.d/Apg-Piper-Yum.repo'},
              },
              managed_repos => ['Apg-Piper-Yum'],
          }
    }

}
