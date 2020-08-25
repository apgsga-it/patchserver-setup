plan piper::ruby_gem_server (
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
      accounts::user { 'geminabox':
        system => true,
        password => 'geminabox'
      }
      $app_dir = "/opt/geminabox"
      $data_dir = "${app_dir}/data"
      file { [$app_dir, $data_dir]:
          ensure => 'directory',
          owner  => 'geminabox',
          group  => 'geminabox',
          mode   => '777',
      }
      $geminabox = "require 'rubygems'
require 'geminabox'
Geminabox.data = '${data_dir}'
use Rack::Session::Pool, expire_after: 1000 # sec
use Rack::Protection
run Geminabox::Server"

      file { '/opt/geminabox/config.ru':
          content => $geminabox,
          replace => true,
          owner  => 'geminabox',
          group  => 'geminabox',
          mode   => '777',
      }
      $unit = "[Unit]
Description=Geminabox
After=network.target

[Service]
User=geminabox
WorkingDirectory=${app_dir}
ExecStart=/opt/rbenv/shims/thin -R ${app_dir}/config.ru -a 0.0.0.0 -p 9292 start

[Install]
WantedBy=multi-user.target"
      systemd::unit_file { 'geminabox.service':
          content => $unit,
          owner => 'geminabox',
          group =>'geminabox',
          mode   => '744',
          enable => true,
      }
      ~> service {'geminabox':
         ensure => 'running',
      }

  }
  run_command('firewall-cmd --permanent --add-port=9292/tcp', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
}