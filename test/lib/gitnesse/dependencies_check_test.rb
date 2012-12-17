require_relative '../../test_helper'

describe Gitnesse::Dependencies do
  describe "#check" do
    before do
      Gitnesse::Dependencies.expects(:check_git)
      Gitnesse::Dependencies.expects(:check_cucumber)
      Gitnesse::Dependencies.expects(:check_repository_url)
      Gitnesse::Dependencies.expects(:check_annotation_info)
    end

    it "calls the other check functions" do
      Gitnesse::Dependencies.check
    end
  end

  describe "#check_repository_url" do
    let(:method) { lambda { Gitnesse::Dependencies.check_repository_url } }

    describe "when repository was defined" do
      before { Gitnesse.configuration.repository_url = "git://github.com/hybridgroup/gitnesse-demo.wiki" }
      it { method.call.must_be_nil }
    end

    describe "when repository was not defined" do
      before { Gitnesse.configuration.repository_url = nil }
      it { method.must_raise(Gitnesse::Dependencies::NoRepositoryURLError) }
    end
  end

  describe "#check_git" do
    let(:method) { lambda { Gitnesse::Dependencies.check_git } }

    describe "when git is not installed" do
      before { Kernel.expects(:system).with("git --version &> /dev/null").returns(false) }
      it { method.must_raise(Gitnesse::Dependencies::NoGitError) }
    end

    describe "when git is installed" do
      before { Kernel.expects(:system).with("git --version &> /dev/null").returns(true) }
      it { method.call.must_be_nil }
    end
  end

  describe "#check_cucumber" do
    let(:method) { lambda { Gitnesse::Dependencies.check_cucumber } }

    describe "when cucumber is not installed" do
      before { Kernel.expects(:system).with("cucumber --version &> /dev/null").returns(false) }
      it { method.must_raise(Gitnesse::Dependencies::NoCucumberError) }
    end

    describe "when cucumber is installed" do
      before { Kernel.expects(:system).with("cucumber --version &> /dev/null").returns(true) }
      it { method.call.must_be_nil }
    end
  end

  describe "#check_annotation_info" do
    let(:method) { lambda { Gitnesse::Dependencies.check_annotation_info } }
    before { Gitnesse.configuration.annotate_results = true }

    describe "when info is defined" do
      before { Gitnesse.configuration.info = "Bob Martin's workstation" }
      it { method.call.must_be_nil }
    end

    describe "when info is not defined" do
      before { Gitnesse.configuration.info = nil }
      it { method.must_raise Gitnesse::Dependencies::NoAnnotationInfoError }
    end
  end
end
