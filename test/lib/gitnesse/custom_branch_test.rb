require_relative '../../test_helper'

describe Gitnesse do
  describe "#branch" do
    it "defaults to 'master'" do
      Gitnesse.branch.must_equal "master"
    end

    it "can be changed" do
      Gitnesse.branch = "wiki"
      Gitnesse.branch.must_equal "wiki"
    end

    it "can be changed through #config" do
      Gitnesse.config do |config|
        config.branch = "wiki"
      end

      Gitnesse.branch.must_equal "wiki"
    end
  end
end
