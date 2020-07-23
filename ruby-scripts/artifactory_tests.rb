#!/usr/bin/env ruby
# encoding: utf-8
require "artifactory"
include Artifactory::Resource
Artifactory.configure do |config|
  # The endpoint for the Artifactory server. If you are running the "default"
  # Artifactory installation using tomcat, don't forget to include the
  # +/artifactoy+ part of the URL.
  config.endpoint = 'https://artifactory4t4apgsga.jfrog.io/artifactory'

  # The basic authentication information. Since this uses HTTP Basic Auth, it
  # is highly recommended that you run Artifactory over SSL.
  config.username = 'dev'
  config.password = 'dev1234'

end
artifact = Artifact.search(name: 'apg-patch-service-cmdclient').first
artifact.download('/tmp')
repo = Repository.find(name: 'repo')
# Ok null ..because no such Repo
puts repo