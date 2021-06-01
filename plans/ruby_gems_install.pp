plan piper::ruby_gems_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
    class { 'rbenv':
       install_dir => '/opt/rbenv',
       latest      => true
    }
    rbenv::gem { 'java': ruby_version => 'jruby-9.2.11.1' }
    rbenv::gem { 'slop': ruby_version => 'jruby-9.2.11.1', version => '>= 4.8.2' }
    rbenv::gem { 'apscli': ruby_version => 'jruby-9.2.11.1', source => "https://${lookup('gem::user::name')}:${lookup(
      'gem::user::pw')}@${gem_repo}" }
    rbenv::gem { 'tty-spinner': ruby_version => 'jruby-9.2.11.1' }
    rbenv::gem { 'apsmig': ruby_version => 'jruby-9.2.11.1', source => "https://${lookup('gem::user::name')}:${lookup(
      'gem::user::pw')}@${gem_repo}" }
    rbenv::gem { 'artcli': ruby_version => 'jruby-9.2.11.1', source => "https://${lookup('gem::user::name')}:${lookup(
      'gem::user::pw')}@${gem_repo}" }
  }
}
