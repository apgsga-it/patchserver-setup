require 'apscli'
module TestCases
  class PatchBuilder
    attr_reader :testcases

    def initialize
      @testcases = {}
      @testcases['EchoServiceAll'] = EchoServiceAll
      @testcases['EchoServiceSingleModule'] = EchoServiceSingleModule
      @testcases['EchoAndCalcServiceSingleModules'] = EchoAndCalcServiceSingleModules
      @testcases['CalcServiceAll'] = CalcServiceAll
      @testcases['UIServiceSome'] = UIServiceSome

    end

    def make(name, patch_number)
      if !@testcases.key?(name)
        puts "Testcase : <#{name}> does not exit"
        puts "Available Testcases : #{self.list.to_s}"
        return nil
      end
      testcase = @testcases[name]
      testcase.make(patch_number)
    end

    def list
      @testcases
    end
  end

  class EchoServiceAll
    def self.make(patch_number)
      dbPatch = Aps::Api::DBPatch.builder().build()
      patch = Aps::Api::Patch
                .builder()
                .patchNumber(patch_number)
                .dbPatch(dbPatch)
                .services(Aps::Api::Lists.newArrayList(
                  Aps::Api::Service
                    .builder()
                    .serviceName("echoservice")
                    .artifactsToPatch(Aps::Api::Lists.newArrayList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.0.DEV-ADMIN-UIMIG-SNAPSHOT").build(),
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-service")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.0.DEV-ADMIN-UIMIG-SNAPSHOT").build()
                    )).build()
                ))
      patch.build()
    end
  end

  class EchoServiceSingleModule
    def self.make(patch_number)
      dbPatch = Aps::Api::DBPatch.builder().build()
      patch = Aps::Api::Patch
                .builder()
                .patchNumber(patch_number)
                .dbPatch(dbPatch)
                .services(Aps::Api::makeList(
                  Aps::Api::Service
                    .builder()
                    .serviceName("echoservice")
                    .artifactsToPatch(Aps::Api::makeList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.0.DEV-ADMIN-UIMIG-SNAPSHOT").build()
                    )).build()
                ))
      patch.build()
    end
  end

  class EchoAndCalcServiceSingleModules
    def self.make(patch_number)
      dbPatch = Aps::Api::DBPatch.builder().build()
      patch = Aps::Api::Patch
                .builder()
                .patchNumber(patch_number)
                .dbPatch(dbPatch)
                .services(Aps::Api::makeList(
                  Aps::Api::Service
                    .builder()
                    .serviceName("echoservice")
                    .artifactsToPatch(Aps::Api::makeList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.0.DEV-ADMIN-UIMIG-SNAPSHOT").build()
                    )).build(),
                  Aps::Api::Service
                    .builder()
                    .serviceName("calctestservice")
                    .artifactsToPatch(Aps::Api::makeList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module-2")
                        .groupId("com.apgsga.testapp2")
                        .version("1.0.1.DEV-ADMIN-UIMIG-SNAPSHOT").build()
                    )).build()
                ))
      patch.build()
    end
  end

  class CalcServiceAll
    def self.make(patch_number)
      dbPatch = Aps::Api::DBPatch.builder().build()
      patch = Aps::Api::Patch
                .builder()
                .patchNumber(patch_number)
                .dbPatch(dbPatch)
                .services(Aps::Api::Lists.newArrayList(
                  Aps::Api::Service
                    .builder()
                    .serviceName("calctestservice")
                    .artifactsToPatch(Aps::Api::makeList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module-2")
                        .groupId("com.apgsga.testapp2")
                        .version("1.0.1.DEV-ADMIN-UIMIG-SNAPSHOT").build(),
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-service-2")
                        .groupId("com.apgsga.testapp2")
                        .version("1.0.1.DEV-ADMIN-UIMIG-SNAPSHOT").build()
                    )).build()
                ))
        patch.build().
        end
    end
  end

  class UIServiceSome
    def self.make(patch_number)
      dbPatch = Aps::Api::DBPatch.builder().build()
      patch = Aps::Api::Patch
                .builder()
                .patchNumber(patch_number)
                .dbPatch(dbPatch)
                .services(Aps::Api::Lists.newArrayList(
                  Aps::Api::Service
                    .builder()
                    .serviceName("it21-test-ui")
                    .artifactsToPatch(Aps::Api::makeList(
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-jadas-appstarter-3")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.3.DEV-ADMIN-UIMIG-SNAPSHOT").build(),
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-module-3")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.3.DEV-ADMIN-UIMIG-SNAPSHOT").build(),
                      Aps::Api::MavenArtifact
                        .builder()
                        .artifactId("testapp-jadas-frameworkstarter-3")
                        .groupId("com.apgsga.testapp")
                        .version("1.0.3.DEV-ADMIN-UIMIG-SNAPSHOT").build(),
                    )).build()
                ))
      patch.build()
    end
  end
end