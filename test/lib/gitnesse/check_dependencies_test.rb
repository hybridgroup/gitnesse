require_relative '../../test_helper'

describe Gitnesse do
  describe "#ensure_repository" do
    let(:method) { lambda { Gitnesse.ensure_repository } }

    describe "when repository was defined" do
      before { Gitnesse.stubs(:repository_url).returns("git://github.com/hybridgroup/gitnesse-demo.wiki") }
      it { method.call.must_be_nil }
    end

    describe "when repository was not defined" do
      before { Gitnesse.stubs(:repository_url).returns(nil) }
      it { method.must_raise(RuntimeError) }
    end
  end

  describe "#ensure_git_available" do
    let(:method) { lambda { Gitnesse.ensure_git_available } }

    describe "when git is not installed" do
      before { Kernel.expects(:system).with("git --version").returns(false) }
      it { method.must_raise(RuntimeError) }
    end

    describe "when git is installed" do
      before { Kernel.expects(:system).with("git --version").returns(true) }
      it { method.call.must_be_nil }
    end
  end

  describe "#ensure_cucumber_available" do
    let(:method) { lambda { Gitnesse.ensure_cucumber_available } }

    describe "when cucumber is not installed" do
      before { Kernel.expects(:system).with("cucumber --version").returns(false) }
      it { method.must_raise(RuntimeError) }
    end

    describe "when cucumber is installed" do
      before { Kernel.expects(:system).with("cucumber --version").returns(true) }
      it { method.call.must_be_nil }
    end
  end
end
