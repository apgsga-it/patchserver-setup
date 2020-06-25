# Class: git
#
class git (
  Boolean $sources_manage,
  String  $sources_repo,
  String  $sources_ensure,
  Boolean $package_manage,
  String  $package_ensure,
  String  $package_name,
  Hash[String, Hash[String, String]]
          $users = lookup('git::users', Hash, 'hash', {}),
) {
  anchor { "${module_name}::begin": }
  -> class { "${module_name}::sources": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::config": }
  -> anchor { "${module_name}::end": }
}
