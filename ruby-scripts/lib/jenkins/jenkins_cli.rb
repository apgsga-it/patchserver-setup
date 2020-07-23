module Jenkins
  class JenkinsCli
    attr_reader :target, :user, :dry_run

    def initialize(target, user, dry_run = false)
      @user = user
      @target = target
      @dry_run = dry_run
    end

    def run
      prefix = pre_cmd()
      cmd = parameter()
      cmdToExecute = "#{prefix} ssh -l #{@user}  -p 53801  #{@target}  #{cmd}"
      if !dry_run then
        system(cmdToExecute)
        puts "Command : #{cmdToExecute} done."
      else
        puts "Dry run, command #{cmdToExecute} not executed."
      end
    end

    def pre_cmd
      return ""
    end

    def parameter
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end

  class CreateJob < JenkinsCli
    attr_reader :job_name, :job_xml_file

    def initialize(target, user, job_name, job_xml_file, dry_run = false)
      super(target, user, dry_run)
      @job_name = job_name
      @job_xml_file = job_xml_file
    end

    def pre_cmd
      return "cat #{job_xml_file} | "
    end

    def parameter
      return "create-job #{job_name}"
    end
  end

  class DeleteJob < JenkinsCli
    attr_reader :job_name

    def initialize(target, user, job_name, dry_run = false)
      super(target, user, dry_run)
      @job_name = job_name
    end

    def parameter
      return "delete-job #{job_name}"
    end
  end

  class BuildJob < JenkinsCli
    attr_reader :job_name

    def initialize(target, user, job_name, dry_run = false)
      super(target, user, dry_run)
      @job_name = job_name
    end

    def parameter
      return "build #{job_name} -v -f -s "
    end
  end

  class Help < JenkinsCli
    attr_reader :job_name

    def initialize(target, user, dry_run = false)
      super(target, user, dry_run)
    end

    def parameter
      return "help"
    end
  end


end
