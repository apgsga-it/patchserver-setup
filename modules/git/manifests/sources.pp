# Class: git::sources
#
class git::sources {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $git::sources_manage {

    case $::facts[os][name] {
      'Ubuntu': {
        require apt
        apt::ppa { $git::sources_repo:
          ensure => $git::sources_ensure,
        }
      }
      default: { }
    }
  }
}
