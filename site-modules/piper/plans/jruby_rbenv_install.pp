plan piper::jruby_rbenv_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
    class { 'rbenv':
      install_dir => '/opt/rbenv',
      latest      => true
    }
    rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
    rbenv::build { 'jruby-9.2.11.1': }
    rbenv::gem { 'java': ruby_version => 'jruby-9.2.11.1' }

  }
}