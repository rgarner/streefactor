# frozen_string_literal: true

require 'syntax_tree'

module Streefactor
  # Remove the outer module from the first module encountered in a file, leaving everything else alone.
  class RemoveOuterModule
    include SyntaxTree::DSL

    attr_reader :source

    def initialize(source)
      @source = source
    end

    def to_final
      format(
        Program(
          Statements(
            parse_details.before +
            parse_details.module_statements_body +
            parse_details.after
          )
        )
      )
    end

    private

    def parse_details # rubocop:disable Metrics/MethodLength
      program in {
        statements: {
          body: [
            *before,
            SyntaxTree::ModuleDeclaration[
              bodystmt: {
                statements: { body: module_statements_body }
              }
            ],
            *after
          ]
        }
      }

      Data.define(:before, :module_statements_body, :after).new(
        before:,
        module_statements_body:,
        after:
      )
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
