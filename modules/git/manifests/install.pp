# Class: git::install
#
class git::install inherits git {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $git::package_manage {
    package { $git::package_name:
      ensure => $git::package_ensure,
      alias  => 'git',
    }
  }
}
