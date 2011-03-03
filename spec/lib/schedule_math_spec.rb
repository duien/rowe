require 'spec_helper'

describe ScheduleMath do
  subject do
    Class.new { include ScheduleMath }.new
  end

  # Reasonable defaults that can be overridden by individual tests or blocks
  # Project that runs from March 1 - March 31 2011
  # Current date is March 7 (fifth weekday)
  before do
    subject.stub(:start_day).and_return(Date.civil(2011, 03, 01))
    subject.stub(:end_day).and_return(Date.civil(2011, 03, 31))
    Date.stub(:today).and_return(Date.civil(2011, 03, 07)) # fifth weekday
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
      Date.stub(:today).and_return(subject.start_day + 1.day)

      subject.should be_started
    end

    it "returns false if the current time is before start_day" do
      Date.stub(:today).and_return(subject.start_day - 1.day)

      subject.should_not be_started
    end
  end

  describe "#ended?" do
    it "returns true if the current time is after end_day" do
      Date.stub(:today).and_return(subject.end_day + 1.day)

      subject.should be_ended
    end

    it "returns false if the current time is before end_day" do
      Date.stub(:today).and_return(subject.end_day - 1.day)

      subject.should_not be_ended
    end

    it "returns false if the current time is exactly the end_day" do
      Date.stub(:today).and_return(subject.end_day)

      subject.should_not be_ended
    end
  end

  describe "#behind?" do
    before do
      # 8 hrs/day
      subject.stub(:budget).and_return(184)
    end

    it "returns true if the project is behind schedule" do
      subject.stub(:completed).and_return(31)

      subject.should be_behind
    end

    it "returns false if the project is not behind schedule" do
      subject.stub(:completed).and_return(32)

      subject.should_not be_behind
    end
  end

  describe "#percent_completed" do
    it "returns 100% if the budget is 0 hours" do
      subject.stub(:budget).and_return(0)

      subject.percent_completed.should == 100
    end

    it "returns the percent completed" do
      subject.stub(:budget).and_return(200)
      subject.stub(:completed).and_return(100)

      subject.percent_completed.should == 50
    end
  end

  describe "#time_per_day" do
    it "returns the number of hours per day that must be worked on average" do
      subject.stub(:budget).and_return(184)

      subject.time_per_day.should == 8.0
    end
  end

  describe "#time_remaining_per_day" do
    it "returns the number of hours that must be worked in the remaining days" do
      subject.stub(:budget).and_return(184)
      subject.stub(:completed).and_return(41.5)

      subject.time_remaining_per_day.should == 7.5
    end

    it "returns the remaining hours if the number of remaining weekdays is 0" do
      subject.stub(:budget).and_return(200)
      subject.stub(:completed).and_return(190)
      Date.stub(:today).and_return(subject.end_day + 1.day)

      subject.time_remaining_per_day.should == 10.0
    end
  end
end
