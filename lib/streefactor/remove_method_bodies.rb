# frozen_string_literal: true

require 'syntax_tree'

module Streefactor
  # Remove bodies from all methods. Useful to generate a stub class from an implementation.
  class RemoveMethodBodies
    include SyntaxTree::DSL

    attr_reader :source

    def initialize(source)
      @source = source
    end

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

    def format(node, width = 120)
      SyntaxTree::Formatter.new(source, [], width).then do |q|
        q.format(node)
        q.flush
        q.output.join
      end
    end

    def program
      @program ||= SyntaxTree.parse(@source)
    end
  end
end
