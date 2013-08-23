require 'spec_helper'

module Gitnesse
  describe Wiki::Page do
    let(:page) { Wiki::Page.new("~/.gitnesse/gitnesse/new_feature.md") }

    it "takes a path and splits it into filename and name" do
      expect(page.name).to eq "new_feature"
      expect(page.filename).to eq "new_feature.md"
      expect(page.path).to eq "~/.gitnesse/gitnesse/new_feature.md"
    end

    describe "#content" do
      it "reads and caches the page's content" do
        File.should_receive(:read).with(page.path).once.and_return("test")

        expect(page.content).to be_a String
        expect(page.content).to eq "test"
      end
    end
  end
end
