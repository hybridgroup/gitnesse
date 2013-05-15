require 'spec_helper'

module Gitnesse
  describe FeatureTransform do
    describe ".convert" do
      it "converts a Cucumber feature to a Markdown wiki page" do
        wiki_page = FeatureTransform.convert(Support.addition_feature)
        expect(wiki_page).to eq Support.wiki_addition_feature
      end
    end
  end
end
