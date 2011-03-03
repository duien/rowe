# In order to use this module, a class must respond to the
# following methods:
#  * budget
#  * completed
#  * start_day
#  * end_day
#
#  The first two should return floats of the number of hours
#  allotted and completed, respectively. The second two should
#  return Date objects for the start and end days that should
#  be used for time range calculations
#
module ScheduleMath

  def remaining
    [self.budget - self.completed, 0].max
  end

  def over
    self.completed - self.budget
  end

  def over_budget?
    # self.over > 0
    self.percent_completed > 100
  end

  def started?
    self.start_day <= Date.today
  end

  def ended?
    self.end_day < Date.today
  end

  def behind?
    self.percent_completed < self.percent_elapsed
  end

  def percent_completed
    return 100 if self.budget == 0
    ((self.completed.to_f / self.budget) * 100).to_i
  end

  def percent_elapsed
    ((self.num_weekdays_elapsed.to_f / self.num_weekdays) * 100).to_i
  end

  def num_weekdays
    Date.weekdays_in_range(self.start_day, self.end_day)
  end

  def num_weekdays_remaining
    start_at = self.started? ? Date.today : self.start_day
    Date.weekdays_in_range(start_at, self.end_day)
  end

  def num_weekdays_elapsed
    end_at = self.ended? ? self.end_day + 1 : Date.today
    Date.weekdays_in_range(self.start_day, end_at) - 1
  end

  def time_per_day
    self.budget / self.num_weekdays
  end

  def time_remaining_per_day
    if self.num_weekdays_remaining <= 0
      self.remaining
    else
      self.remaining / self.num_weekdays_remaining
    end
  end

  def time_per_day_so_far
    if self.num_weekdays_elapsed <= 0
      0
    else
      self.completed / self.num_weekdays_elapsed
    end
  end
  
end
