# frozen_string_literal: true

require 'syntax_tree'
require_relative 'base'

module Streefactor
  # Remove bodies from all methods. Useful to generate a stub class from an implementation.
  class RemoveMethodBodies < Base
    def to_final = format(program.accept(remove_methods))

    private

    def remove_methods
      SyntaxTree.mutation do |visitor|
        visitor.mutate('DefNode') do |node|
          node.copy(
            bodystmt: BodyStmt(
              Statements([VoidStmt()]), nil, nil, nil, nil
            )
          )
        end
      end
    end
  end
end
