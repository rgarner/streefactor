# frozen_string_literal: true

require 'syntax_tree'
require_relative 'base'

module Streefactor
  # Remove the outer module from the first module encountered in a file, leaving everything else alone.
  class RemoveOuterModule < Base
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
  end
end
