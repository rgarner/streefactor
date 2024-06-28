require 'streefactor/remove_method_bodies'
require 'streefactor/remove_outer_module'
require 'streefactor/pipeline'

RSpec.describe Streefactor::Pipeline do
  subject(:pipeline) { Streefactor::Pipeline(&block) }

  context 'multiple steps are given' do
    let(:block) { proc { Streefactor::RemoveMethodBodies | Streefactor::RemoveOuterModule } }

    describe '#steps' do
      subject { pipeline.steps }
      it { is_expected.to eql([Streefactor::RemoveMethodBodies, Streefactor::RemoveOuterModule]) }
    end

    describe '#to_final' do
      subject { pipeline.to_final(source) }

      let(:source) do
        <<~RUBY
          module IsRemoved
            class StrippedBare
              def add_one(other)
                other + 1
              end

              def add_two(other)
                add_one(add_one(other))
              end
            end
          end
        RUBY
      end

      it {
        is_expected.to eql <<~RUBY
          class StrippedBare
            def add_one(other)
            end

            def add_two(other)
            end
          end
        RUBY
      }
    end
  end
end
