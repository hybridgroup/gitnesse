require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:result) do
      <<-EOS
Current Gitnesse Configuration:
    repository_url - [not set]
      features_dir - features
            branch - master
  annotate_results - [not set]
        identifier - [not set]
      EOS
    end

    it "prints the current configuration" do
      expect(Gitnesse::ConfigLoader).to receive(:find_and_load)
      expect(gitnesse("info")).to eq result
    end
  end
end
