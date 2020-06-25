# This file was automatically generated on 2020-06-25 15:47:54 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# The client-side description of a zypper repository. Repository
# configurations are found by parsing `/etc/zypp/zypper.conf` and
# the files indicated by the `reposdir` option in that file
# (see `zypper(8)` for details).
# 
# Most parameters are identical to the ones documented
# in the `zypper(8)` man page.
# 
# Continuation lines that zypper supports (for the `baseurl`, for example)
# are not supported. This type does not attempt to read or verify the
# exinstence of files listed in the `include` attribute.
Puppet::Resource::ResourceType3.new(
  'zypprepo',
  [
    # A human-readable description of the repository.
    # This corresponds to the name parameter in `zypper(8)`.
    # Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/.*/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/.*/]], 'descr'),

    # The URL that holds the list of mirrors for this repository.
    # Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/.*/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/.*/]], 'mirrorlist'),

    # The URL for this repository. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/.*/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/.*/]], 'baseurl'),

    # The path relative to the baseurl. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/.*/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/.*/]], 'path'),

    # Whether this repository is enabled, as represented by a
    # `0` or `1`. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/(0|1)/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/(0|1)/]], 'enabled'),

    # Whether to check the GPG signature on packages installed
    # from this repository, as represented by a `0` or `1`.
    # Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/(0|1)/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/(0|1)/]], 'gpgcheck'),

    # The URL for the GPG key with which packages from this
    # repository are signed. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/.*/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/.*/]], 'gpgkey'),

    # Priority of this repository from 1-99. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/[1-9][0-9]?/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/[1-9][0-9]?/]], 'priority'),

    # Enable autorefresh of the repository, as represented by a
    # `0` or `1`. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/(0|1)/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/(0|1)/]], 'autorefresh'),

    # Enable RPM files caching, as represented by a
    # `0` or `1`. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/(0|1)/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/(0|1)/]], 'keeppackages'),

    # The type of software repository. Values can match
    # `yast2` or `rpm-md` or `plaindir` or `yum` or `NONE`. Set this to `absent` to remove it from the file completely.
    # 
    # Valid values are `absent`. Values can match `/yast2|rpm-md|plaindir|yum|NONE/`.
    Puppet::Resource::Param(Variant[Enum['absent'], Pattern[/yast2|rpm-md|plaindir|yum|NONE/]], 'type')
  ],
  [
    # The name of the repository.  This corresponds to the
    # `repositoryid` parameter in `zypper(8)`.
    Puppet::Resource::Param(Any, 'name', true)
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
