class Project
  include MongoMapper::EmbeddedDocument
  include ScheduleMath

  key :name, String
  key :hours, Hash
  key :budget, Float, :default => 0.0
  key :start_day, Date
  key :end_day, Date
  key :billable, Boolean, :default => true

  key :freckle_id, Integer
  embedded_in :month

  def billable?
    self.attributes[:billable] || self.budget > 0
  end

  def completed
    self.attributes[:completed] || hours.values.inject(&:+) || 0.0
  end

  def custom_dates?
    self.start_day? || self.end_day?
  end

  def start_day
    start_day? ? super : self.month.start_day
  end

  def end_day
    end_day? ? super : self.month.end_day
  end

end
