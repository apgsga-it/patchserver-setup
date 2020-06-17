# This file was automatically generated on 2020-06-17 14:17:58 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' user account information
Puppet::Resource::ResourceType3.new(
  'jenkins_user',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Optional longer account name.
    Puppet::Resource::Param(Any, 'full_name'),

    # email address
    Puppet::Resource::Param(Any, 'email_address'),

    # Unhashed or 'plain_text' API token that is digested to produce the public API token
    Puppet::Resource::Param(Any, 'api_token_plain'),

    # Literal public API token.  read-only property.
    Puppet::Resource::Param(Any, 'api_token_public'),

    # Array of ssh public key strings
    Puppet::Resource::Param(Any, 'public_keys'),

    # Password for HudsonPrivateSecurityRealm
    Puppet::Resource::Param(Any, 'password')
  ],
  [
    # Account login name.  Jenkins calls this 'id'
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `jenkins_user`
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
