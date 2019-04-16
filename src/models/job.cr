module Mssh
  class Job < Component
    YAML.mapping(
      name: String,
      commands: Array(String),
    )

    def process_commands(variables : Variables?)
      @commands.each_with_index do |cmd, i|
        if cmd.includes? "${"
          # throws exception if variable prefix defines but variables section does not define
          raise "There is no defined variable in yaml file" unless variables

          # start index
          s = cmd.index("${").not_nil!

          # end index
          e = cmd.index("}").not_nil!

          # trim as variable name for yaml file
          var_name = cmd[s..e].delete { |s| ['$', '{', '}'].includes?(s) }

          if vv = variables.find { |v| v.name == var_name }
            @commands[i] = cmd.gsub("${#{var_name}}", vv.value)
          end
        end
      end

      @commands
    end

    def queued(groups : Groups, variables : Variables?)
      groups.each do |group|
        group.flatten_nodes.each do |node|
          executable = Executable.new(
            node.host,
            node.port || group.port || Mssh::Defaults.port,
            node.user || group.user || Mssh::Defaults.user,
            node.key || group.key || Mssh::Defaults.key,
            process_commands(variables),
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
