require 'spec_helper'

module Gitnesse
  describe FeatureTransform do
    describe ".convert" do
      context "when a feature is passed" do
        it "converts a Cucumber feature to a Markdown wiki page" do
          wiki_page = FeatureTransform.convert(Support.addition_feature)
          expect(wiki_page).to eq Support.wiki_addition_feature
        end
      end

      context "when a non-feature string is passed" do
        it "returns a 'undefined feature' page" do
          result = <<-EOS.chomp
# Undefined Feature

This feature hasn't been added yet.
          EOS
          expect(FeatureTransform.convert('')).to eq result
        end
      end
    end
  end
end
