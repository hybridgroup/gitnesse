require_relative '../../test_helper'

describe Gitnesse do
  describe ".ensure_repository" do
    let(:_method) { lambda { Gitnesse.ensure_repository } }

    describe "when repository was defined" do
      before { Gitnesse.stubs(:repository_url).returns("git://github.com/hybridgroup/gitnesse-demo.wiki") }
      it { _method.call.must_be_nil }
    end

    describe "when repository was not defined" do
      before { Gitnesse.stubs(:repository_url).returns(nil) }
      it { _method.must_raise(RuntimeError) }
    end
  end

  describe ".ensure_git_available" do
    let(:_method) { lambda { Gitnesse.ensure_git_available } }

    describe "when git is not installed" do
      before { Kernel.expects(:system).with("git --version").returns(false) }
      it { _method.must_raise(RuntimeError) }
    end

    describe "when git is installed" do
      before { Kernel.expects(:system).with("git --version").returns(true) }
      it { _method.call.must_be_nil }
    end
  end

  describe ".ensure_cucumber_available" do
    let(:_method) { lambda { Gitnesse.ensure_cucumber_available } }

    describe "when cucumber is not installed" do
      before { Kernel.expects(:system).with("cucumber --version").returns(false) }
      it { _method.must_raise(RuntimeError) }
    end

    describe "when cucumber is installed" do
      before { Kernel.expects(:system).with("cucumber --version").returns(true) }
      it { _method.call.must_be_nil }
    end
  end

  describe ".branch" do
    let(:_method) { lambda { Gitnesse.branch } }

    describe "when no branch has been defined" do
      before { Gitnesse.branch = nil }
      it { _method.call.must_equal "master" }
    end

    describe "when a custom branch has been defined" do
      before { Gitnesse.branch = "features" }
      it { _method.call.must_equal "features" }
    end
  end

  describe ".commit_info" do
    describe "when git username and email are defined" do
      before do
        Gitnesse.expects(:read_git_config).with("user.name").returns("Bob Smith")
        Gitnesse.expects(:read_git_config).with("user.email").returns("bob@bobsmith.com")
      end

      let(:_method) { lambda { Gitnesse.commit_info } }

      it { _method.call.must_equal({ :name => "Bob Smith",
                                    :email => "bob@bobsmith.com",
                                    :message => "Update features with Gitnesse" }) }
    end
  end

  describe ".read_git_config" do
    describe "when a value is set" do
      before do
        Gitnesse.stubs(:`).with("git config --get user.email").returns("bob@bobsmith.com\n")
        $?.stubs(:success?).returns(true)
      end

      let(:_method) { lambda { Gitnesse.read_git_config("user.email") } }

      it { _method.call.must_equal "bob@bobsmith.com" }
    end
  end
end
