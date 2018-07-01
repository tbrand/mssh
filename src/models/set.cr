module Mssh
  class Set < Component
    YAML.mapping(
      name: String,
      jobs: Array(String),
      groups: Array(String),
    )
  end

  alias Sets = Array(Set)
end
