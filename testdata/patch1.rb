#!/usr/bin/env ruby
# encoding: utf-8
require 'apscli'

dbPatch = Apscli::ApsApi::DBPatch.builder().build()
patch = Apscli::ApsApi::Patch
          .builder()
          .patchNumber("3")
          .dbPatch(dbPatch)
          .services(Apscli::ApsApi::Lists.newArrayList(
           Apscli::ApsApi::Service
             .builder()
             .serviceName("echoservice")
             .artifactsToPatch(Apscli::ApsApi::Lists.newArrayList(
               Apscli::ApsApi::MavenArtifact
                 .builder()
                 .artifactId("testapp-module")
                 .groupId("com.apgsga.testapp")
                 .version("1.0.0.DEV-ADMIN-UIMIG-SNAPSHOT").build()
             )).build()
         ))
om = Apscli::ApsApi::ObjectMapper.new()
output = Apscli::ApsApi::File.new("Patch3.json")
om.writeValue(output, patch.build())