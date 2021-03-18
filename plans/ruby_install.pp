plan piper::ruby_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
  class { 'rbenv':
    install_dir => '/opt/rbenv',
    latest      => true
  }
  rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
  rbenv::build { '2.6.6':}
  rbenv::build { 'jruby-9.2.11.1': global => true  }
  rbenv::gem { 'java': ruby_version => 'jruby-9.2.11.1' }
  rbenv::gem { 'slop': ruby_version => 'jruby-9.2.11.1', version => '>= 4.8.2' }
  rbenv::gem { 'apscli': ruby_version => 'jruby-9.2.11.1', version => '>= 0.8.2', source => "https://${lookup('gem::user::name')}:${lookup('gem::user::pw')}@${gem_repo}" }
  rbenv::gem { 'tty-spinner': ruby_version => 'jruby-9.2.11.1'}
  rbenv::gem { 'apsmig': ruby_version => 'jruby-9.2.11.1' , version => '>= 0.2.6', source => "https://${lookup('gem::user::name')}:${lookup('gem::user::pw')}@${gem_repo}"}
  }
}
