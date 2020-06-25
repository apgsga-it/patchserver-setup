# Class: git::config
#
class git::config () inherits git {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  create_resources('git::user', $git::users)
}
