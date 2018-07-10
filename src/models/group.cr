module Mssh
  class Group < Component
    YAML.mapping(
      name: String,
      nodes: Nodes?,
      user: String?,
      key: String?,
      port: Int32?,
      groups: Array(String)?,
    )

    def flatten_nodes : Nodes
      _nodes = [] of Node
      _nodes.concat(@nodes.not_nil!) unless @nodes.nil?

      if group_names = groups
        _groups = __config.find_groups(group_names)
        _group_nodes = _groups.map { |g| g.nodes }.flatten.compact
        _nodes.concat(_group_nodes)
      end

      _nodes
    end
  end

  alias Groups = Array(Group)
end
