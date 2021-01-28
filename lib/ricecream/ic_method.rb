# frozen_string_literal: true

module Ricecream
  ICMethod = Struct.new("ICMethod", :name, :script, :lineno, :column, :arity, :args)
end
