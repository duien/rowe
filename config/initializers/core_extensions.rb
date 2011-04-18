class Date
  def self.weekdays_in_range(start_day, end_day, options={})
    raise ArgumentError, 'dates must be provided' unless start_day.kind_of? Date and end_day.kind_of? Date
    (start_day..end_day).inject(0) do |count, day|
      if options[:skip].present? and options[:skip].include? day.day
        count
      elsif day.weekday?
        count +1
      else
        count
      end
    end
  end

  def weekday?
    wday == 0 || wday == 6 ? false : true
  end

end
