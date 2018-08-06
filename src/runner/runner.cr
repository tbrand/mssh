module Mssh
  class Runner

    @config_path : String?
    @job         : String?
    @group       : String?
    @set         : String?
    @parallel    : Int32 = 1
    @log_dir     : String = Defaults.log_dir

    def initialize
    end

    def parse!
      OptionParser.parse! do |parser|
        parser.banner = t_desc("\n mssh: execute commands on multiple host via ssh\n")

        parser.on("-c PATH", "--config=PATH", "configuration path") do |path|
          @config_path = path
        end

        parser.on("-j JOB", "--job=JOB", "job to be executed (for multiple jobs: --job=job1,job2)") do |job|
          @job = job
        end

        parser.on("-g GROUP", "--group=GROUP", "group to be executed (for multiple groups: --group=g1,g2)") do |group|
          @group = group
        end

        parser.on("-s SET", "--set=SET", "set of job and group to be executed") do |set|
          @set = set
        end

        parser.on("-d DIR", "--directory=DIR", "directory for storing logs (./.mssh for default)") do |dir|
          @log_dir = dir
        end

        parser.on("-l LOG_LEVEL", "--log-level=LOG_LEVEL", "log level (one of 'verbose', 'info' or 'none'. default is 'info')") do |log_level|
          Logger.set_log_level(log_level)
        end

        parser.on("-p NUM", "--parallel=NUM", "number of parallel execution") do |num|
          @parallel = num.to_i
        end

        parser.on("-h", "--help", "show this help") do
          puts parser
          puts
          exit 0
        end
      end
    rescue e : OptionParser::InvalidOption
      puts t_error(e.message.not_nil!)
      puts t_error("`mssh -h` to show help message.")
      exit -1
    end

    def run
      L.info "start runnning mssh..."

      unless config_path = @config_path
        raise "specify config path by '-c' PATH. `mssh -h` to show help message."
      end

      jobs = if job = @job
               job.split(",")
             else
               [] of String
             end

      groups = if group = @group
                 group.split(",")
               else
                 [] of String
               end

      config = Mssh::Config.init(config_path, @parallel, @log_dir)
      config.execute(jobs, groups, @set)
    rescue e : Exception
      L.error e.message.not_nil!

      if _config = config
        if _config.groups.size > 0
          L.error ""
          L.error "Here are available groups (specify by '-g')"

          _config.groups.each do |group|
            L.error " - #{group.name}"
          end
        else
          L.error ""
          L.error "No groups are found in the configuration."
        end

        if _config.jobs.size > 0
          L.error ""
          L.error "Here are available jobs (specify by '-j')"

          _config.jobs.each do |job|
            L.error " - #{job.name}"
          end
        else
          L.error ""
          L.error "No jobs are found in the configuration"
        end

        if _config.sets && _config.sets.not_nil!.size > 0
          L.error ""
          L.error "Here are available sets (specify by '-s')"

          _config.sets.not_nil!.each do |set|
            L.error " - #{set.name}"
          end
        else
          L.error ""
          L.error "No sets are found in the configuration"
        end
      end
    end

    include Mssh
    include Theme
  end
end
