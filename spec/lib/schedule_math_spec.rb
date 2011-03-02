require 'spec_helper'

describe ScheduleMath do
  subject do
    Class.new { include ScheduleMath }.new
  end

  describe "#remaining" do
    it "returns the difference between the number of hours completed and the budget" do
      subject.stub(:budget).and_return(100)
      subject.stub(:completed).and_return(25)

      subject.remaining.should == 75
    end

    it "returns 0 if the number of completed hours exceeds the budget" do
      subject.stub(:budget).and_return(100)
      subject.stub(:completed).and_return(125)

      subject.remaining.should == 0
    end
  end

  describe "#over" do
    it "returns the number of completed hours over the budget" do
      subject.stub(:budget).and_return(100)
      subject.stub(:completed).and_return(133)

      subject.over.should == 33
    end
  end
end
