module Mssh
  class Runner

    @config_path : String?
    @job         : String?
    @group       : String?
    @set         : String?
    @parallel    : Int32 = 1
    @log_dir     : String = default_log_dir

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

          raise "\n\n  sorry, parallel execution is not supported now.\n\n  see => URL\n\n" if @parallel > 1
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
        puts t_error("specify config path by '-c PATH'")
        puts t_error("`mssh -h` to show help message.")
        exit -1
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
    end

    include Mssh
    include Theme
  end
end
