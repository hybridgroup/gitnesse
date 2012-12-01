require_relative '../../test_helper'

describe Gitnesse do
  describe "#generate_commit_info" do
    let(:method) { lambda { Gitnesse.generate_commit_info } }

    before do
      Gitnesse::GitConfig.expects(:read).with("user.name").returns("Bob Smith")
      Gitnesse::GitConfig.expects(:read).with("user.email").returns("bob@bobsmith.com")
    end

    it { method.call.must_equal({ :name => "Bob Smith",
                                  :email => "bob@bobsmith.com",
                                  :message => "Update features with Gitnesse" }) }
  end
end
