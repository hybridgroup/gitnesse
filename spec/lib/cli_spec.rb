require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    describe "-v, --version" do
      it "outputs the gem name and version" do
        expect(gitnesse("--version")).to eq "gitnesse #{Gitnesse::VERSION}\n"
        expect(gitnesse("-v")).to eq "gitnesse #{Gitnesse::VERSION}\n"
      end
    end
  end
end
