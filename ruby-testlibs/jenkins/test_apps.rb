# frozen_string_literal: true

#  Jenkins Module
# ==================================================
#
#  A module for manipulating Jenkins Testjobs
#
module Jenkins
  require 'yaml'
  require 'facets/string/snakecase'
  #  Visitor Interface
  module Visitable
    def accept(visitor)
      visitor.visit(self)
    end
  end
  #  Testapps Class , which contains all Testapp Data
  class TestApps
    attr_reader :user, :pw, :target, :test_apps, :gradle_home, :maven_home, :artifactory_admin, :artifactory_uri, :maven_profile
    include Visitable

    def initialize(inventory_file, config_file)
      inventory = YAML.load_file(inventory_file)
      @user = inventory['groups'].first['config']['ssh']['user']
      # We could encrypted this , as secret .... but since this only for local testing
      @pw = inventory['groups'].first['config']['ssh']['password']
      @target = inventory['groups'].first['targets'].first['uri']
      @gradle_home = inventory['vars']['gradle_home']
      @maven_home = inventory['vars']['maven_home']
      @artifactory_uri = inventory['vars']['artifactory_uri']
      @maven_profile = inventory['groups'].first['vars']['maven_profile']
      @test_apps = []
      config = YAML.load_file(config_file)
      @artifactory_admin = config['artifactory']['admin']
      apps_config_context = config['testapps']
      apps_config_context.each do |app_config_context|
        modules_names = app_config_context['modules'].split(' ')
        modules = []
        modules_names.each do |module_name|
          modules << MavenModule.new(module_name)
        end
        pkg_names = app_config_context['pkg'].split(' ')
        pkgs = []
        pkg_names.each do |pkg|
          pkgs << PkgModule.new(pkg)
        end
        @test_apps << TestApp.new(self, app_config_context['name'], app_config_context['rootdir'], modules, pkgs)
      end
    end
  end
  #  Testapp Class , which contains all Data for a Testapp
  class TestApp
    attr_reader :test_apps, :name, :root_dir, :modules, :pkgs
    include Visitable
    def initialize(test_apps, name, root_dir, modules, pkgs)
      @test_apps = test_apps
      @name = name
      @root_dir = root_dir
      @modules = modules
      @modules.each do |mod|
        mod.test_app = self
      end
      @pkgs = pkgs
      @pkgs.each do |pkg|
        pkg.test_app = self
      end
    end

    def user
      @test_apps.user
    end

    def target
      @test_apps.target
    end
  end
  #  Module Class , which contains all Data for a Module
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

    attr_writer :test_app
  end
  #  Maven Module
  class MavenModule < Module
    include Visitable
    def initialize(name)
      super(name)
    end
  end
  #  A Gradle Pkg Module
  class PkgModule < Module
    include Visitable
    def initialize(name)
      super(name)
    end
  end

  #  Default Visitor Class for Visitors
  class BaseVisitor
    def visit(subject)
      clz_name = subject.class.name
      clz_name['Jenkins::'] = ''
      clz_name_snake_case = clz_name.snakecase
      method_name = "_visit_#{clz_name_snake_case}"
      send(method_name, subject)
    end

    def _visit_test_apps(subject)
      visit_test_apps(subject)
      subject.test_apps.each do |test_app|
        test_app.accept(self)
      end
    end

    def _visit_test_app(subject)
      visit_test_app(subject)
      subject.modules.each do |mod|
        mod.accept(self)
      end
      subject.pkgs.each do |pkg|
        pkg.accept(self)
      end
    end

    def _visit_maven_module(subject)
      visit_maven_module(subject)
    end

    def _visit_pkg_module(subject)
      visit_pkg_module(subject)
    end

    # To be implemented by sublasses
    def visit_test_apps(subject); end

    def visit_test_app(subject); end

    def visit_maven_module(subject); end

    def visit_pkg_module(subject); end
  end

  #  Visitor, which prints the Testapps Data
  class TestAppsPrinter < BaseVisitor
    def visit_test_apps(_subject)
      puts 'Visiting a the TestApps'
    end

    def visit_test_app(subject)
      puts "Visiting a the TestApp: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end

    def visit_maven_module(subject)
      puts "Visiting the MavenModule: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end

    def visit_pkg_module(subject)
      puts "Visiting the PkgModule: #{subject.name}, root_dir: #{subject.root_dir}, target: #{subject.target},user: #{subject.user}"
    end
  end
  class TestAppsJobRunner < BaseVisitor
    attr_reader :opts, :maven_renderer
    include Jenkins

    def initialize(opts)
      @opts = opts
    end

    def visit_test_apps(_subject)
      puts 'Starting Build of Jenkins Jobs for TestApps'
    end

    def visit_maven_module(subject)
      return if @opts[:runAppJobs] && @opts[:runAppJobs] != subject.test_app.name

      Jenkins::BuildJob.new(subject.target, subject.user, job_name(subject.name), @opts[:dry]).run
    end

    def visit_pkg_module(subject)
      return if @opts[:runAppJobs] && @opts[:runAppJobs] != subject.test_app.name
      return if @opts[:skipPkgs]

      Jenkins::BuildJob.new(subject.target, subject.user, job_name(subject.name), opts[:dry]).run
    end
  end

  class TestAppsJobCreator < BaseVisitor
    attr_reader :opts, :maven_renderer
    def initialize(opts)
      @opts = opts
    end

    def visit_test_apps(_subject)
      puts 'Generation Jenkings Jobs for TestApps'
    end

    def visit_test_app(_subject)
      @mavenRenderer = Jenkins::Renderer.new('maven-job-config.xml.erb')
    end

    def visit_maven_module(subject)
      return if @opts[:createAppJobs] && @opts[:createAppJobs] != subject.test_app.name

      result = @mavenRenderer.render(subject.name, { root_dir: subject.root_dir })
      Jenkins::CreateJob.new(subject.target, subject.user, result[:job_name], result[:job_xml_file], @opts[:dry]).run
    end

    def visit_pkg_module(subject)
      return if @opts[:createAppJobs] && @opts[:createAppJobs] != subject.test_app.name

      renderer = Jenkins::Renderer.new('gradle-job-config.xml.erb')
      result = renderer.render(subject.name, { root_dir: subject.root_dir })
      Jenkins::CreateJob.new(subject.target, subject.user, result[:job_name], result[:job_xml_file], opts[:dry]).run
    end
  end

  class TestAppsJobDeleter < BaseVisitor
    include Jenkins
    attr_reader :opts
    def initialize(opts)
      @opts = opts
    end

    def visit_test_apps(_subject)
      puts 'Deleting Jenkins Jobs for TestApps'
    end

    def visit_maven_module(subject)
      return if @opts[:deleteAppJobs] && @opts[:deleteAppJobs] != subject.test_app.name

      Jenkins::DeleteJob.new(subject.target, subject.user, job_name(subject.name), @opts[:dry]).run
    end

    def visit_pkg_module(subject)
      return if @opts[:deleteAppJobs] && @opts[:deleteAppJobs] != subject.test_app.name

      Jenkins::DeleteJob.new(subject.target, subject.user, job_name(subject.name), @opts[:dry]).run
    end
  end

end
