# This file was automatically generated on 2020-06-25 15:47:53 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' number of executor slots
Puppet::Resource::ResourceType3.new(
  'jenkins_num_executors',
  [
    # Valid values are `present`.
    Puppet::Resource::Param(Enum['present'], 'ensure')
  ],
  [
    # Number of executors
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `jenkins_num_executors`
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
