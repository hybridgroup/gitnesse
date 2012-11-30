require_relative '../../test_helper'

describe Gitnesse do
  describe "#generate_commit_info" do
    let(:method) { lambda { Gitnesse.generate_commit_info } }

    describe "with a defined git username and email" do
      before do
        Gitnesse.expects(:read_git_config).with("user.name").returns("Bob Smith")
        Gitnesse.expects(:read_git_config).with("user.email").returns("bob@bobsmith.com")
      end

      it { method.call.must_equal({ :name => "Bob Smith",
                                    :email => "bob@bobsmith.com",
                                    :message => "Update features with Gitnesse" }) }
    end

    describe "without a defined git username and email" do
      before do
        Gitnesse.commit_info = nil
        Gitnesse.expects(:read_git_config).with("user.name").returns('')
        Gitnesse.expects(:read_git_config).with("user.email").returns('')
      end

      it { method.must_raise RuntimeError }
    end
  end
end
