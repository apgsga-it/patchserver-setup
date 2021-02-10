plan addons::ruby_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
    class { 'rbenv':
      install_dir => '/opt/rbenv',
      latest      => true
    }
    rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
    rbenv::build { '2.6.6': global => true }
    rbenv::build { 'jruby-9.2.11.1':  }
    rbenv::gem { 'java': ruby_version => 'jruby-9.2.11.1' }

  }
}