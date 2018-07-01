module Mssh
  class Group < Component
    YAML.mapping(
      name: String,
      nodes: Nodes,
      user: String?,
      key: String?,
      port: Int32?,
      groups: Array(String)?,
    )

    def flatten
      return unless group_names = groups

      _groups = __config.find_groups(group_names)

      @nodes = [
        @nodes,
        _groups.map { |g| g.nodes }.flatten,
      ].flatten
    end
  end

  alias Groups = Array(Group)
end
