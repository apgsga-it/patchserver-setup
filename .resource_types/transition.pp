# This file was automatically generated on 2020-09-16 12:06:02 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Define a transitional state.
Puppet::Resource::ResourceType3.new(
  'transition',
  [
    # Enable or disable this conditional state transition. Valid values
    # are true or false.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'enable')
  ],
  [
    # The resource for which a transitional state is being defined. This
    # should be a resource reference (e.g. Service['apache']). This resource
    # will be made to autorequire the transitional state.
    Puppet::Resource::Param(Any, 'resource'),

    # The hash of attributes to set on the resource when applying a
    # transitional state. Each hash key must be a valid attribute for the
    # resource being transitioned.
    Puppet::Resource::Param(Any, 'attributes'),

    # An array of resources to check for synchronization. If any of these
    # resources are out of sync (change pending), then this transitional state
    # will be applied. These resources will each be made to autorequire the
    # transitional state.
    Puppet::Resource::Param(Any, 'prior_to'),

    # This parameter does not serve any function beyond setting the
    # resource's name.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `transition`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Ruby provider for transition type. This provider is not platform
    #   specific.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
