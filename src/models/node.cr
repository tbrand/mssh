module Mssh
  class Node < Component
    YAML.mapping(
      host: String,
      port: Int32?,
      user: String?,
      key: String?,
    )
  end

  alias Nodes = Array(Node)
end
