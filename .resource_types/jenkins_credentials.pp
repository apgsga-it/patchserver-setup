# This file was automatically generated on 2020-10-06 15:57:58 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage Jenkins' credentials
# 
# XXX The properties specified are not validated against the specified
#     jenkins class (`impl`)
Puppet::Resource::ResourceType3.new(
  'jenkins_credentials',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # credentials domain within jenkins - :undef indicates the "global" domain
    # 
    # Valid values are `undef`.
    Puppet::Resource::Param(Enum['undef'], 'domain'),

    # credentials scope within jenkins
    # 
    # Valid values are `GLOBAL`, `SYSTEM`.
    Puppet::Resource::Param(Enum['GLOBAL', 'SYSTEM'], 'scope'),

    # name of the java class implimenting the credential
    # 
    # Valid values are `UsernamePasswordCredentialsImpl`, `BasicSSHUserPrivateKey`, `ConduitCredentialsImpl`, `StringCredentialsImpl`, `FileCredentialsImpl`, `AWSCredentialsImpl`, `GitLabApiTokenImpl`, `GoogleRobotPrivateKeyCredentials`, `BrowserStackCredentials`.
    Puppet::Resource::Param(Enum['UsernamePasswordCredentialsImpl', 'BasicSSHUserPrivateKey', 'ConduitCredentialsImpl', 'StringCredentialsImpl', 'FileCredentialsImpl', 'AWSCredentialsImpl', 'GitLabApiTokenImpl', 'GoogleRobotPrivateKeyCredentials', 'BrowserStackCredentials'], 'impl'),

    # description of credentials
    Puppet::Resource::Param(Any, 'description'),

    # username for credentials - UsernamePasswordCredentialsImpl, CertificateCredentialsImpl, BrowserStackCredentials
    Puppet::Resource::Param(Any, 'username'),

    # password - UsernamePasswordCredentialsImpl, CertificateCredentialsImpl
    Puppet::Resource::Param(Any, 'password'),

    # ssh private key string - BasicSSHUserPrivateKey
    Puppet::Resource::Param(Any, 'private_key'),

    # AWS access key - AWSCredentialsImpl, BrowserStackCredentials
    Puppet::Resource::Param(Any, 'access_key'),

    # AWS secret key - AWSCredentialsImpl
    Puppet::Resource::Param(Any, 'secret_key'),

    # passphrase to unlock ssh private key - BasicSSHUserPrivateKey
    Puppet::Resource::Param(Any, 'passphrase'),

    # secret string - StringCredentialsImpl
    Puppet::Resource::Param(Any, 'secret'),

    # name of file - FileCredentialsImpl
    Puppet::Resource::Param(Any, 'file_name'),

    # content of file - FileCredentialsImpl, CertificateCredentialsImpl
    Puppet::Resource::Param(Any, 'content'),

    # content of file - CertificateCredentialsImpl
    Puppet::Resource::Param(Any, 'source'),

    # name of the java class implimenting the key store - CertificateCredentialsImpl
    Puppet::Resource::Param(Any, 'key_store_impl'),

    # conduit token - ConduitCredentialsImpl
    Puppet::Resource::Param(Any, 'token'),

    # API token - GitLabApiTokenImpl
    Puppet::Resource::Param(Any, 'api_token'),

    # URL of phabriactor installation - ConduitCredentialsImpl
    Puppet::Resource::Param(Any, 'url'),

    # Prettified JSON key string - GoogleRobotPrivateKeyCredentials
    Puppet::Resource::Param(Any, 'json_key'),

    # Email address used with a P12 key - GoogleRobotPrivateKeyCredentials
    Puppet::Resource::Param(Any, 'email_address'),

    # P12 key string in Base64 format without line wrapping - GoogleRobotPrivateKeyCredentials
    Puppet::Resource::Param(Any, 'p12_key')
  ],
  [
    # Id for credentials entry
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `jenkins_credentials`
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
