require 'spec_helper'

module Gitnesse
  describe CommitInfoGenerator do
    describe ".generate" do
      before do
        GitConfigReader.should_receive(:read).with('user.name').and_return("Bob Martin")
        GitConfigReader.should_receive(:read).with('user.email').and_return("unclebob@gmail.com")
      end

      let(:result) { CommitInfoGenerator.generate }

      it "returns a hash" do
        expect(result).to be_a Hash
      end

      it "contains the user's name and email" do
        expect(result[:name]).to eq "Bob Martin"
        expect(result[:email]).to eq "unclebob@gmail.com"
      end

      it "contains a commit message" do
        expect(result[:message]).to eq "Updated features with Gitnesse."
      end
    end
  end
end
