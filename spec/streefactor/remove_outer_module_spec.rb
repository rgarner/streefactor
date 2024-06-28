require 'streefactor/remove_outer_module'

RSpec.describe Streefactor::RemoveOuterModule do
  let(:refactor) { described_class.new(source) }

  describe '#to_final' do
    subject { refactor.to_final }

    context 'a module contains some statements' do
      let(:source) do
        <<~RUBY
          require 'something'

          module ToRemove
            class BecomesTopLevel
              def some_method
                1 + 1
              end
            end

            def becomes_top_level
              puts 'hello'
            end
          end

          # some comment
        RUBY
      end

      it {
        is_expected.to eq <<~RUBY
          require "something"

          class BecomesTopLevel
            def some_method
              1 + 1
            end
          end

          def becomes_top_level
            puts "hello"
          end

          # some comment
        RUBY
      }
    end
  end
end
