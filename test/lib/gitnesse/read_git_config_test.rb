require_relative '../../test_helper'

describe Gitnesse do
  describe "#read_git_config" do
    let(:method) { lambda { Gitnesse.read_git_config("user.email") } }

    describe "when a gitconfig value is set" do
      before do
        Gitnesse.expects(:`).with("git config --get user.email").returns("bob@bobsmith.com\n")
        $?.expects(:success?).returns(true)
      end

      it { method.call.must_equal "bob@bobsmith.com" }
    end

    describe "when a gitconfig value is set globally" do
      before do
        Gitnesse.expects(:`).with("git config --get user.email").returns("")
        Gitnesse.expects(:`).with("git config --get --global user.email").returns("bob@bobsmith.com\n")
      end

      it { method.call.must_equal "bob@bobsmith.com" }
    end

    describe "when a gitconfig value is not set" do
      before do
        Gitnesse.expects(:`).with("git config --get user.email").returns("")
        Gitnesse.expects(:`).with("git config --get --global user.email").returns("")
      end

      it { method.call.must_equal "" }
    end
  end
end
