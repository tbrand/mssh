module Mssh
  class Job < Component
    YAML.mapping(
      name: String,
      commands: Array(String),
    )

    def queued(groups : Groups)
      groups.each do |group|
        group.nodes.each do |node|
          executable = Executable.new(
            node.host,
            node.port || group.port || Mssh::Defaults.port,
            node.user || group.user || Mssh::Defaults.user,
            node.key  || group.key  || Mssh::Defaults.key,
            @commands,
            __log_dir,
          )

          Queue.global << executable
        end
      end
    end

    include Mssh
  end

  alias Jobs = Array(Job)
end
