module Mssh
  class Job < Component
    YAML.mapping(
      name: String,
      commands: Array(String),
    )

    def process_commands(variables : VariableList)
      return @commands unless variables_not_nil = variables

      @commands.each_with_index do |cmd, i|
        commands[i] = variables_not_nil.reduce(cmd) { |c, v| c.gsub(/\${#{v[:name]}}/, v[:value]) }
      end

      @commands
    end

    def queued(groups : Groups, variables : Variables?)
      v_list = to_tupple(variables)
      groups.each do |group|
        group.flatten_nodes.each do |node|
          executable = Executable.new(
            node.host,
            node.port || group.port || Mssh::Defaults.port,
            node.user || group.user || Mssh::Defaults.user,
            node.key || group.key || Mssh::Defaults.key,
            process_commands(v_list),
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
