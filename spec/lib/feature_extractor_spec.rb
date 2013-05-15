require 'spec_helper'

module Gitnesse
  describe FeatureExtractor do
    let(:wiki_page_to_extract) { Support.example_wiki_page }
    let(:expected_features) { Support.example_features }

    describe ".extract!" do
      it "extracts Cucumber features from Markdown wiki pages" do
        extracted_page = FeatureExtractor.extract!(wiki_page_to_extract)
        expect(extracted_page).to eq expected_features
      end

      it "returns false if no examples were found" do
        expect(FeatureExtractor.extract!("")).to be_false
      end
    end
  end
end
