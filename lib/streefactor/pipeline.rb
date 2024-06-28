# frozen_string_literal: true

module Streefactor # rubocop:disable Style/Documentation
  def self.Pipeline(&)
    Streefactor::Pipeline.new(&)
  end

  # Chain refactorings
  class Pipeline
    attr_reader :steps

    def initialize(&)
      @steps = instance_eval(&)
    end

    def to_final(source)
      steps.inject(source) do |current_source, refactoring|
        refactoring.new(current_source).to_final
      end
    end
  end
end
