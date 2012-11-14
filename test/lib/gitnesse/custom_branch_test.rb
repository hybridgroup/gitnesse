require_relative '../../test_helper'

describe Gitnesse do
  describe "#branch" do
    describe "defaults to 'master'" do
      before { Gitnesse.branch nil }
      it { Gitnesse.branch.must_equal "master" }
    end

    describe "when changed" do
      before { Gitnesse.branch "wiki" }
      it { Gitnesse.branch.must_equal "wiki" }
    end

    describe "when changed through #config" do
      before do
        Gitnesse.config do
          branch "wiki"
        end
      end

      it { Gitnesse.branch.must_equal "wiki" }
    end
  end
end
