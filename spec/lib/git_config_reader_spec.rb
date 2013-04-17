require 'spec_helper'

describe Gitnesse::GitConfigReader do
  describe ".read" do
    let(:reader) { -> { Gitnesse::GitConfigReader.read('user.email') } }

    context "when a gitconfig value is not set" do
      before do
        Gitnesse::GitConfigReader.should_receive(:`).with('git config --get user.email').and_return('')
        Gitnesse::GitConfigReader.should_receive(:`).with('git config --get --global user.email').and_return('')
      end

      it "raises Gitnesse::GitConfigReader::NoValueSetError" do
        expect(reader).to raise_error Gitnesse::GitConfigReader::NoValueSetError
      end
    end

    context "when a gitconfig value is set" do
      before do
        Gitnesse::GitConfigReader.should_receive(:`).with('git config --get user.email').and_return("bob@example.com\n")
      end

      it "returns the gitconfig value" do
        expect(reader.call).to eq "bob@example.com"
      end
    end

    context "when a gitconfig value is set globally" do
      before do
        Gitnesse::GitConfigReader.should_receive(:`).with('git config --get user.email').and_return("")
        Gitnesse::GitConfigReader.should_receive(:`).with('git config --get --global user.email').and_return("bob@example.com\n")
      end

      it "returns the gitconfig value" do
        expect(reader.call).to eq "bob@example.com"
      end
    end
  end
end
