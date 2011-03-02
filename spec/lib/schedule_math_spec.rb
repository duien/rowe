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

  describe "#over_budget?" do
    it "returns true if the project is over budget" do
      subject.stub(:budget).and_return(50)
      subject.stub(:completed).and_return(55)

      subject.should be_over_budget
    end

    it "returns false if the project is under budget" do
      subject.stub(:budget).and_return(50)
      subject.stub(:completed).and_return(45)

      subject.should_not be_over_budget
    end
  end

  describe "#started?" do
    it "returns true if the current time is after start_day" do
      subject.stub(:start_day).and_return(Date.yesterday)

      subject.should be_started
    end

    it "returns false if the current time is before start_day" do
      subject.stub(:start_day).and_return(Date.tomorrow)

      subject.should_not be_started
    end
  end

  describe "ended?" do
    it "returns true if the current time is after end_day" do
      subject.stub(:end_day).and_return(Date.yesterday)

      subject.should be_ended
    end

    it "returns false if the current time is before end_day" do
      subject.stub(:end_day).and_return(Date.tomorrow)

      subject.should_not be_ended
    end
  end
end
