# frozen_string_literal: true

module Jenkins
  require 'erb'
  require 'tmpdir'
  class Renderer
    attr_reader :template, :temp_dir, :renderer
    include Jenkins

    def initialize(template_file_name)
      template_file = File.join(File.dirname(__FILE__), "../templates/#{template_file_name}")
      if !File.exist?(template_file) || !File.readable?(template_file)
        raise ArgumentError, "The #{template_file_name} does not exist or is not readable, exiting"
      end

      template = File.read(template_file)
      erb = ERB.new(template)
      @renderer = erb.def_class(RenderData_, 'render()')
      @temp_dir = Dir.mktmpdir('jenkins')
    end

    def render(module_name, attributes = {})
      output = renderer.new(module_name, attributes).render
      job_name = job_name(module_name)
      puts "Jobname : #{job_name}"
      job_xml_file = File.join(@temp_dir, "#{job_name}.xml")
      File.write(job_xml_file, output)
      { job_name: job_name, job_xml_file: job_xml_file }
    end
  end

  class RenderData_
    def initialize(module_name, attributes = {})
      @module_name = module_name
      attributes.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
  end
end
