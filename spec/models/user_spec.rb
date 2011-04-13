require 'spec_helper'

describe User do
  context "case-insensitive login" do
    it "should downcase email when saving" do
      u = User.new(:email => 'Test@Example.com')
      u.save
      u.email.should == 'test@example.com'
    end

    describe ".find_for_authentication" do
      it "should use downcased email" do
        User.should_receive(:first).with(hash_including(:conditions => { :email => 'test@example.com' })).once
        User.find_for_authentication(:email => 'Test@Example.com')
      end
    end
  end
end
