require 'spec_helper'

module Gitnesse
  describe GitConfigReader do
    describe ".read" do
      let(:reader) { -> { GitConfigReader.read('user.email') } }

      context "when a gitconfig value is not set" do
        before do
          GitConfigReader.should_receive(:`).with('git config --get user.email').and_return('')
          GitConfigReader.should_receive(:`).with('git config --get --global user.email').and_return('')
        end

        it "raises GitConfigReader::NoValueSetError" do
          expect(reader).to raise_error GitConfigReader::NoValueSetError
        end
      end

      context "when a gitconfig value is set" do
        before do
          GitConfigReader.should_receive(:`).with('git config --get user.email').and_return("bob@example.com\n")
        end

        it "returns the gitconfig value" do
          expect(reader.call).to eq "bob@example.com"
        end
      end

      context "when a gitconfig value is set globally" do
        before do
          GitConfigReader.should_receive(:`).with('git config --get user.email').and_return("")
          GitConfigReader.should_receive(:`).with('git config --get --global user.email').and_return("bob@example.com\n")
        end

        it "returns the gitconfig value" do
          expect(reader.call).to eq "bob@example.com"
        end
      end
    end
  end
end
