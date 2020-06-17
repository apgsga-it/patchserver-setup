# This file was automatically generated on 2020-06-17 11:06:02 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# Manage archive file download, extraction, and cleanup.
Puppet::Resource::ResourceType3.new(
  'archive',
  [
    # whether archive file should be present/absent (default: present)
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # if file/directory exists, will not download/extract archive.
    Puppet::Resource::Param(Any, 'creates')
  ],
  [
    # namevar, archive file fully qualified file path.
    Puppet::Resource::Param(Any, 'path', true),

    # archive file name (derived from path).
    Puppet::Resource::Param(Any, 'filename'),

    # whether archive will be extracted after download (true|false).
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'extract'),

    # target folder path to extract archive.
    Puppet::Resource::Param(Any, 'extract_path'),

    # target folder path to extract archive. (this parameter is for camptocamp/archive compatibility)
    Puppet::Resource::Param(Any, 'target'),

    # custom extraction command ('tar xvf example.tar.gz'), also support sprintf format ('tar xvf %s') which will be processed with the filename: sprintf('tar xvf %s', filename)
    Puppet::Resource::Param(Any, 'extract_command'),

    # Specify an alternative temporary directory to use for copying files, if unset then the operating system default will be used.
    Puppet::Resource::Param(Any, 'temp_dir'),

    # custom extraction options, this replaces the default flags. A string such as 'xvf' for a tar file would replace the default xf flag. A hash is useful when custom flags are needed for different platforms. {'tar' => 'xzf', '7z' => 'x -aot'}.
    Puppet::Resource::Param(Any, 'extract_flags'),

    # whether archive file will be removed after extraction (true|false).
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'cleanup'),

    # archive file source, supports puppet|http|https|ftp|file|s3 uri.
    Puppet::Resource::Param(Any, 'source'),

    # archive file source, supports http|https|ftp|file uri.
    # (for camptocamp/archive compatibility)
    Puppet::Resource::Param(Any, 'url'),

    # archive file download cookie.
    Puppet::Resource::Param(Any, 'cookie'),

    # archive file checksum (match checksum_type).
    # 
    # Valid values are `true`, `false`, `undef`, ``, ``. Values can match `/\b[0-9a-f]{5,128}\b/`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'undef', '', ''], Pattern[/\b[0-9a-f]{5,128}\b/]], 'checksum'),

    # archive file checksum (match checksum_type)
    # (this parameter is for camptocamp/archive compatibility).
    # 
    # Values can match `/\b[0-9a-f]{5,128}\b/`.
    Puppet::Resource::Param(Pattern[/\b[0-9a-f]{5,128}\b/], 'digest_string'),

    # archive file checksum source (instead of specifying checksum)
    Puppet::Resource::Param(Any, 'checksum_url'),

    # archive file checksum source (instead of specifying checksum)
    # (this parameter is for camptocamp/archive compatibility)
    Puppet::Resource::Param(Any, 'digest_url'),

    # archive file checksum type (none|md5|sha1|sha2|sha256|sha384|sha512).
    # 
    # Valid values are `none`, `md5`, `sha1`, `sha2`, `sha256`, `sha384`, `sha512`.
    Puppet::Resource::Param(Enum['none', 'md5', 'sha1', 'sha2', 'sha256', 'sha384', 'sha512'], 'checksum_type'),

    # archive file checksum type (none|md5|sha1|sha2|sha256|sha384|sha512)
    # (this parameter is camptocamp/archive compatibility).
    # 
    # Valid values are `none`, `md5`, `sha1`, `sha2`, `sha256`, `sha384`, `sha512`.
    Puppet::Resource::Param(Enum['none', 'md5', 'sha1', 'sha2', 'sha256', 'sha384', 'sha512'], 'digest_type'),

    # whether checksum wil be verified (true|false).
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'checksum_verify'),

    # username to download source file.
    Puppet::Resource::Param(Any, 'username'),

    # password to download source file.
    Puppet::Resource::Param(Any, 'password'),

    # extract command user (using this option will configure the archive file permission to 0644 so the user can read the file).
    Puppet::Resource::Param(Any, 'user'),

    # extract command group (using this option will configure the archive file permisison to 0644 so the user can read the file).
    Puppet::Resource::Param(Any, 'group'),

    # proxy type (none|ftp|http|https)
    # 
    # Valid values are `none`, `ftp`, `http`, `https`.
    Puppet::Resource::Param(Enum['none', 'ftp', 'http', 'https'], 'proxy_type'),

    # proxy address to use when accessing source
    Puppet::Resource::Param(Any, 'proxy_server'),

    # ignore HTTPS certificate errors
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'allow_insecure'),

    # provider download options (affects curl, wget, and only s3 downloads for ruby provider)
    Puppet::Resource::Param(Any, 'download_options'),

    # The specific backend to use for this `archive`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # curl
    # : * Required binaries: `curl`.
    #   * Default for `feature` == `posix`.
    # 
    # ruby
    # : * Required binaries: `aws`.
    #   * Default for `feature` == `microsoft_windows`.
    # 
    # wget
    # : * Required binaries: `wget`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['path']
  },
  true,
  false)
