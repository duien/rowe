require 'spec_helper'

describe Date do
  describe ".weekdays_in_range" do
    it "raises an ArgumentError when start_day is not a Date instance" do
      expect {
        Date.weekdays_in_range(nil, Date.today)
      }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError when end_day is not a Date instance" do
      expect {
        Date.weekdays_in_range(Date.today, nil)
      }.to raise_error(ArgumentError)
    end
  end
end
