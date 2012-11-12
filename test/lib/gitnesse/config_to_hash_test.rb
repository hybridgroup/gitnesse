require_relative '../../test_helper'

describe Gitnesse do
  describe ".config_to_hash" do
    let(:method) { lambda { Gitnesse.config_to_hash } }
    before do
      Gitnesse.config do |config|
        config.repository_url   = "git://github.com/hybridgroup/gitnesse-demo.wiki.git"
        config.branch           = "wiki"
        config.target_directory = "feature_files"
      end
    end

    it { method.call.must_be_instance_of Hash }

    it "contains the configuration data" do
      hash = method.call

      hash["repository_url"].must_equal "git://github.com/hybridgroup/gitnesse-demo.wiki.git"
      hash["branch"].must_equal "wiki"
      hash["target_directory"].must_equal "feature_files"
    end
  end
end
