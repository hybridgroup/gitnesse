require_relative '../../test_helper'

describe Gitnesse::Configuration do
  describe "#branch" do
    describe "defaults to 'master'" do
      it { Gitnesse.configuration.branch.must_equal "master" }
    end

    describe "when changed" do
      before { Gitnesse.configuration.branch = "wiki" }
      it { Gitnesse.configuration.branch.must_equal "wiki" }
    end

    describe "when changed through #configure" do
      before do
        Gitnesse.configure do |config|
          config.branch = "wiki"
        end
      end

      it { Gitnesse.configuration.branch.must_equal "wiki" }
    end
  end
end
