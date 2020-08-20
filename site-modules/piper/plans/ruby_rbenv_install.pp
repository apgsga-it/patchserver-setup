plan piper::ruby_rbenv_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
  class { 'rbenv':
      install_dir => '/opt/rbenv',
      latest      => true
  }
  rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
  rbenv::build { 'jruby-9.2.13.0': }
  rbenv::build { '2.6.6': global => true  }
  rbenv::gem { 'java': ruby_version => 'jruby-9.2.13.0' }
  rbenv::gem { 'geminabox': ruby_version => '2.6.6', skip_docs => true, timeout => 1200}
  rbenv::gem { 'thin': ruby_version => '2.6.6', skip_docs => true, timeout => 1200 }
  }
}