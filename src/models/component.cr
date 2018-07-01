module Mssh
  class Component
    def __config : Config
      Config.global
    end

    def __groups
      __config.groups
    end

    def __jobs
      __config.jobs
    end

    def __executor
      __config.executor
    end

    def __log_dir
      __config.log_dir
    end
  end
end
