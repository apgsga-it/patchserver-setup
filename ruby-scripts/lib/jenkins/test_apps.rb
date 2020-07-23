module Jenkins
  require 'yaml'
  module Visitable
    def accept(visitor)
      visitor.visit(self)
    end
  end
  class TestApps
    attr_reader :user,:pw, :target, :test_apps,:gradle_home, :maven_home
    include Visitable

    def initialize
      bolt_inventory_file = File.join(File.dirname(__FILE__), "../../../inventory.yaml")
      if (!File.exist?(bolt_inventory_file) or !File.readable?(bolt_inventory_file))
        raise ArgumentError.new("The necessary puppet/bolt inventory.yaml file does not exist or is not readable, exiting")
      end
      inventory = YAML.load_file(bolt_inventory_file)
      @user = inventory['groups'].first['config']['ssh']['user']
      # We could encrtypd this , as secret .... but since this only for local testing
      @pw = inventory['groups'].first['config']['ssh']['password']
      @target = inventory['groups'].first['targets'].first['uri']
      @gradle_home = inventory["vars"]["gradle_home"]
      @maven_home = inventory["vars"]["maven_home"]
      @test_apps = []
      apps_config_context = inventory["vars"]["testapps"]
      apps_config_context.each do |app_config_context|
        modules_names = app_config_context["modules"].split(" ")
        modules = []
        modules_names.each do  |module_name|
          modules << MavenModule.new(module_name)
        end
        pkg = PkgModule.new(app_config_context["pkg"])
        @test_apps << TestApp.new(self,app_config_context["name"],app_config_context["rootdir"],modules,pkg)
      end
    end
  end

  class TestApp
    attr_reader :test_apps,:name, :root_dir, :modules, :pkg
    include Visitable
    def initialize(test_apps,name,root_dir, modules, pkg)
      @test_apps = test_apps
      @name = name
      @root_dir = root_dir
      @modules = modules
      @modules.each do |mod|
        mod.test_app = self
      end
      @pkg = pkg
      @pkg.test_app = self
    end
    def user
      @test_apps.user
    end
    def target
      @test_apps.target
    end
  end

  class Module
    attr_reader :name, :test_app
    def initialize(name)
      @name = name
    end
    def user
      @test_app.user
    end
    def target
      @test_app.target
    end
    def root_dir
      @test_app.root_dir
    end
    def test_app=(test_app)
      @test_app = test_app
    end
  end
  class MavenModule < Module
    include Visitable
    def initialize(name)
      super(name)
    end
  end
  class PkgModule < Module
    include Visitable
    def initialize(name)
      super(name)
    end
  end


  class BaseVisitor
    def visit(subject)
      clz_name = subject.class.name
      clz_name["Jenkins::"] = ""
      method_name = "_visit_#{clz_name}".intern
      send(method_name, subject )
    end
    def _visit_TestApps(subject)
      visit_TestApps(subject)
      subject.test_apps.each do |test_app|
        test_app.accept(self)
      end
    end
    def _visit_TestApp(subject)
      visit_TestApp(subject)
      subject.modules.each do |mod|
        mod.accept(self)
      end
      subject.pkg.accept(self)
    end
    def _visit_MavenModule(subject)
      visit_MavenModule(subject)
    end
    def _visit_PkgModule(subject)
      visit_PkgModule(subject)
    end

    # To be implemented by sublasses
    def visit_TestApps(subject)
    end

    def visit_TestApp(subject)
    end

    def visit_MavenModule(subject)
    end
    def visit_PkgModule(subject)
    end
  end


  class PrintingVisitor < BaseVisitor
    def visit_TestApps(subject)
      puts "Visiting a the TestApps"
    end
    def visit_TestApp(subject)
      puts "Visiting a the TestApp: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end
    def visit_MavenModule(subject)
      puts "Visiting the MavenModule: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end
    def visit_PkgModule(subject)
      puts "Visiting the PkgModule: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end
  end
end


