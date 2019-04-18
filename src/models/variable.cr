module Mssh
  class Variable
    YAML.mapping(
      name: String,
      value: String,
    )
  end

  def to_tupple(variables : Variables?) : VariableList
    return nil unless variables_not_nil = variables

    data = [] of VariableItem

    variables_not_nil.each_with_index do |v, i|
      data.push({name: v.name, value: v.value})
    end

    data
  end

  alias Variables = Array(Variable)
  alias VariableItem = NamedTuple(name: String, value: String)
  alias VariableList = Array(VariableItem)?
end
