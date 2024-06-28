# frozen_string_literal: true

require 'syntax_tree'

module Streefactor
  # Base class for refactorings taking some source
  class Base
    include SyntaxTree::DSL

    attr_reader :source

    def initialize(source)
      @source = source
    end

    def to_final = raise NotImplementedError

    protected

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
