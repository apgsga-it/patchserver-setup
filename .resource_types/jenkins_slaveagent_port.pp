# This file was automatically generated on 2020-07-15 13:57:27 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' slave agent listening port
Puppet::Resource::ResourceType3.new(
  'jenkins_slaveagent_port',
  [
    # Valid values are `present`.
    Puppet::Resource::Param(Enum['present'], 'ensure')
  ],
  [
    # port number
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `jenkins_slaveagent_port`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # cli
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
