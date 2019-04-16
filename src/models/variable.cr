module Mssh
  class Variable
    YAML.mapping(
      name: String,
      value: String,
    )
  end

  alias Variables = Array(Variable)
end
