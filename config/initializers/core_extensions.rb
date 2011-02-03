class Date
  def self.weekdays_in_range(start_day, end_day)
    raise ArguementError, 'dates must be provided' unless start_day.kind_of? Date and end_day.kind_of? Date
    (start_day..end_day).inject(0) do |count, day|
      day.wday == 0 || day.wday == 6 ? count : count + 1 # sunday or saturday
    end
  end
end
