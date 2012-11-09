require_relative '../../test_helper'

describe Gitnesse do
  describe "#read_git_config" do
    let(:method) { lambda { Gitnesse.read_git_config("user.email") } }

    describe "when a gitconfig value is not set" do
      before do
        $?.stubs(:success?).returns(false)
        Gitnesse.stubs(:`).with("git config --get user.email").returns("")
        Gitnesse.stubs(:`).with("git config --get --global user.email").returns("")
      end

      it { method.call.must_equal "" }
    end

    describe "when a gitconfig value is set" do
      before do
        $?.stubs(:success?).returns(true)
        Gitnesse.stubs(:`).with("git config --get user.email").returns("bob@bobsmith.com\n")
      end

      it { method.call.must_equal "bob@bobsmith.com" }
    end

    # describe "when a gitconfig value is set globally" do
    #   before do
    #     Gitnesse.stubs(:`).with("git config --get user.email").returns("")
    #     Gitnesse.stubs(:`).with("git config --get --global user.email").returns("bob@bobsmith.com\n")
    #   end

    #   it { method.call.must_equal "bob@bobsmith.com" }
    # end
  end
end
