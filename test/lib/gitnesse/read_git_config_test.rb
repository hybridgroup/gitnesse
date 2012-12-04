require_relative '../../test_helper'

describe Gitnesse::GitConfig do
  describe "#read" do
    let(:method) { lambda { Gitnesse::GitConfig.read("user.email") } }

    describe "when a gitconfig value is not set" do
      before do
        Gitnesse::GitConfig.stubs(:`).with("git config --get user.email").returns("")
        Gitnesse::GitConfig.stubs(:`).with("git config --get --global user.email").returns("")
      end

      it { method.must_raise(Gitnesse::GitConfig::NoValueSetError) }
    end

    describe "when a gitconfig value is set" do
      before do
        Gitnesse::GitConfig.stubs(:`).with("git config --get user.email").returns("bob@bobsmith.com\n")
      end

      it { method.call.must_equal "bob@bobsmith.com" }
    end

    describe "when a gitconfig value is set globally" do
      before do
        Gitnesse::GitConfig.stubs(:`).with('git config --get user.email').returns('')
        Gitnesse::GitConfig.stubs(:`).with('git config --get --global user.email').returns("bob@bobsmith.com\n")
      end

      it { method.call.must_equal "bob@bobsmith.com" }
    end
  end
end
