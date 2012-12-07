require_relative '../../test_helper'

describe Gitnesse::Configuration do
  describe "defaults" do
    subject { Gitnesse::Configuration.new }
    it { subject.branch.must_equal "master" }
    it { subject.annotate_results.must_equal false }
    it { subject.info.must_be_nil }
    it { subject.target_directory.must_equal File.join(Dir.pwd, "features") }
  end
end
