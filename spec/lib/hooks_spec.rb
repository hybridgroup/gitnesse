require 'spec_helper'
require 'pry'

module Gitnesse
  describe Hooks do
    let(:hook) { File.expand_path("#{File.dirname(__FILE__)}/../../lib/gitnesse/hooks/gitnesse.rb") }
    let(:path) { Hooks::PATH }
    let(:dir) { Hooks::DIR }

    before do
      allow(File).to receive(:directory?).with(dir).and_return(true)
    end

    it "sets DIR to the 'support' cucumber dir" do
      expect(dir).to include "features/support"
    end

    it "sets PATH to the filename for the Cucumber hook" do
      expect(path).to include "features/support/gitnesse.rb"
    end

    describe ".create!" do
      before do
        expect(FileUtils).to receive(:cp).with(hook, path)
      end

      it "copies the hooks to the support dir" do
        Hooks.create!
      end

      it "creates the support dir if it doesn't exist" do
        expect(File).to receive(:directory?).with(dir).and_return(false)
        expect(FileUtils).to receive(:mkdir_p).with(dir).and_return(nil)
        Hooks.create!
      end
    end

    describe ".destroy!" do
      it "removes the Gitnesse hooks from the Cucumber support dir" do
        expect(FileUtils).to receive(:rm).with(path, force: true).and_return(nil)
        Hooks.destroy!
      end
    end
  end
end
