# This file was automatically generated on 2020-09-16 12:06:01 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' authorization strategy
Puppet::Resource::ResourceType3.new(
  'jenkins_authorization_strategy',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # List of arguments to security realm class constructor
    Puppet::Resource::Param(Any, 'arguments')
  ],
  [
    # Name of the security realm class
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `jenkins_authorization_strategy`
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
