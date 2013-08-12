require 'spec_helper'

module Gitnesse
  describe Wiki::Page do
    let(:page) { Wiki::Page.new("~/.gitnesse/gitnesse/new_feature.md") }

    it "takes a path and splits it into filename and name" do
      expect(page.name).to eq "new_feature"
      expect(page.filename).to eq "new_feature.md"
      expect(page.path).to eq "~/.gitnesse/gitnesse/new_feature.md"
    end
  end
end
