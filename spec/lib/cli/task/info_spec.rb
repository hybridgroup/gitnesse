require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:result) do
      <<-EOS
Current Gitnesse Configuration:
  annotate_results - [not set]
            branch - master
       commit_info - [not set]
      features_dir - features
    repository_url - [not set]
      EOS
    end

    it "prints the current configuration" do
      expect(gitnesse("info")).to eq result
    end
  end
end
