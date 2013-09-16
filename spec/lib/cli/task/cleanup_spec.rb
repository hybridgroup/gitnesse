require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:help) do
      <<-EOS
USAGE: gitnesse cleanup

Cleans up project folders in ~/.gitnesse

Cleans up the folders for local copies of wikis Gitnesse leaves in ~/.gitnesse.

Examples:
  gitnesse cleanup  # will remove all subfolders from ~/.gitnesse
      EOS
    end

    it "has help info" do
      expect(gitnesse("help cleanup")).to eq help
    end
  end
end
