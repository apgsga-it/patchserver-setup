# This file was automatically generated on 2020-07-15 13:57:28 +0200.
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'loginctl_user',
  [
    # Whether linger is enabled for the user.
    # 
    # Valid values are `enabled`, `disabled`.
    Puppet::Resource::Param(Enum['enabled', 'disabled'], 'linger')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `loginctl_user`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : * Required binaries: `loginctl`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
