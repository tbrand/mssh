module Mssh
  class Config
    YAML.mapping(
      groups: Groups,
      jobs: Jobs,
      sets: Sets?,
    )

    setter executor : Executor? = nil
    setter log_dir  : String?   = nil
    setter parallel : Int32     = 1

    @@config : Config? = nil

    def self.init(
         config_path : String,
         parallel    : Int32,
         log_dir     : String,
         executor    : Executor = ExecutorDefault.new) : Config
      config = Config.from_yaml(File.read(config_path))
      config.executor = executor
      config.parallel = parallel
      config.log_dir = log_dir

      L.verbose "executor: #{executor.class.name}"
      L.verbose "parallel: #{parallel}"
      L.verbose "log directory: #{log_dir}"

      @@config = config
      @@config.not_nil!
    end

    def self.global : Config
      raise "configuration not initialized" unless config = @@config
      config
    end

    def execute(job_names : Array(String), group_names : Array(String), _set_name : String? = nil)
      L.verbose "set degree of parallelism to #{@parallel} for job queue"

      Queue.init(@parallel)
      Queue.global.loop

      jobs = find_jobs(job_names)
      groups = find_groups(group_names)

      if jobs.empty? || groups.empty?
        raise "no job or group have been specified. " +
              "specify them by '-j job', '-g group' or '-s set'" unless set_name = _set_name

        set = find_set(set_name)

        jobs = find_jobs(set.jobs)
        groups = find_groups(set.groups)
      end

      raise "no jobs or groups have been specified. " +
            "specify them by '-j job', '-g group' or '-s set'" if jobs.empty? || groups.empty?

      L.verbose "jobs: #{jobs.map { |j| j.name }}"
      L.verbose "groups: #{groups.map { |g| g.name }}"

      jobs.each do |job|
        L.verbose "queueing #{job.name} for #{groups.map { |g| g.name}}"
        job.queued(groups)
      end

      Queue.global.wait
    end

    def find_jobs(job_names : Array(String)) : Jobs
      j = [] of Job

      job_names.each do |job_name|
        if job = @jobs.find { |j| j.name == job_name }
          j << job
        end
      end

      j
    end

    def find_groups(group_names : Array(String)) : Groups
      g = [] of Group

      group_names.each do |group_name|
        if group = @groups.find { |g| g.name == group_name }
          group.flatten

          g << group
        end
      end

      g
    end

    def find_set(set_name : String) : Set
      raise "failed to find set of #{set_name}. (no set is defined.)" unless sets = @sets

      unless found_set = sets.find { |s| s.name == set_name }
        raise "failed to find set of #{set_name}. " +
              "(available set are #{sets.map { |s| s.name }})"
      end

      found_set
    end

    def executor : Executor
      raise "executor is not found" unless executor = @executor
      executor
    end

    def log_dir : String
      raise "log directory is not found" unless log_dir = @log_dir
      log_dir
    end
  end
end
