plan piper::piper_properties (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     download_file('/etc/opt/ssh_config', '~/Downloads', $targets)
}
