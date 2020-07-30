# This file was automatically generated on 2020-07-29 18:11:18 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' jobs
Puppet::Resource::ResourceType3.new(
  'jenkins_job',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # XML job configuration string
    Puppet::Resource::Param(Any, 'config'),

    # enable/disable job
    Puppet::Resource::Param(Any, 'enable')
  ],
  [
    # job name
    Puppet::Resource::Param(Any, 'name', true),

    # enable/disable displaying configuration diff
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'show_diff'),

    # replace existing job
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'replace'),

    # The specific backend to use for this `jenkins_job`
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
