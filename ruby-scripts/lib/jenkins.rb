require_relative 'jenkins/jenkins_cli'
require_relative 'jenkins/test_apps'
require_relative 'jenkins/renderer'

module Jenkins

  def job_name(module_name)
    job_name_parts = module_name.split("-")
    job_name = ""
    job_name_parts.each do |part|
      job_name += part.capitalize()
    end
    return job_name
  end
end