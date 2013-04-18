require 'spec_helper'

module Gitnesse
  describe FeatureExtractor do
    let(:expected_features) { [example_feature.chomp, another_example_feature.chomp] }
    let(:wiki_page_to_extract) { example_wiki_page }

    describe ".extract!" do
      it "extracts Cucumber features from Markdown wiki pages" do
        extracted_page = FeatureExtractor.extract!(example_wiki_page)
        expect(extracted_page).to eq expected_features
      end

      it "returns false if no examples were found" do
        expect(FeatureExtractor.extract!("")).to be_false
      end
    end
  end
end
