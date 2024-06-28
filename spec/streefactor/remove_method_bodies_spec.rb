require 'streefactor/remove_method_bodies'

RSpec.describe Streefactor::RemoveMethodBodies do
  let(:refactor) { described_class.new(source) }

  describe '#to_final' do
    subject { refactor.to_final }

    context 'a class has one method' do
      let(:source) do
        <<~RUBY
          class Test
            def some_method
              x = 1
              'body to remove'
            end
          end
        RUBY
      end

      it 'removes the method body' do
        is_expected.to eq <<~RUBY
          class Test
            def some_method
            end
          end
        RUBY
      end
    end
  end
end
