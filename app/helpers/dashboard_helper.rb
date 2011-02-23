module DashboardHelper
  def status_class(project)
    status_classes = []
    status_classes << 'over-budget' if project.over_budget?
    status_classes << 'behind' if project.behind?
    status_classes << 'unstarted' if !project.started?
    status_classes << 'ended' if project.ended?
    status_classes
  end

  def format_time(time)
    # puts time.seconds.class
    hours = time / 1
    minutes = ( time % 1 ) * 60
    "%d:%02d" % [ hours, minutes ]
  end

  def format_date(date)
    case date
    when Date.today then 'today'
    when Date.today + 1 then 'tomorrow'
    when Date.today - 1 then 'yesterday'
    else date.strftime("%b #{date.day.ordinalize}")
    end
  end

  def special_text(project)
    text = []
    text << "#{project.started? ? 'started' : 'starts'} #{format_date(project.start_day)}" if project.respond_to?(:start_day?) and project.start_day?
    text << "#{project.ended? ? 'ended' : 'ends'} #{format_date(project.end_day)}" if project.respond_to?(:end_day?) and project.end_day?
    text << more_text(project)
    raw(text.compact.join(', ')) unless text.blank?
  end

  def more_text(project)
    text = []
    text << "#{project.num_weekdays_remaining} days left" if project.started? and not project.ended?
    if project.percent_completed - project.percent_elapsed < 0
      should_have_done = project.time_per_day * project.num_weekdays_elapsed
      to_catch_up = should_have_done - project.completed
      text << %(<span class="catch-up">#{format_time to_catch_up} by end of day</span>)
    else
      should_have_done = project.time_per_day * project.num_weekdays_elapsed
      ahead = project.completed - should_have_done
      text << %(<span class="ahead">#{format_time ahead} ahead</span>)
    end
    text.compact.join(', ') unless text.blank?
  end

  def progress_text(project)
    completed_difference = project.percent_completed - project.percent_elapsed
    if project.ended?
      if project.remaining > 0
        'You missed the deadline'
      else
        'Completed'
      end
    elsif !project.started? 
      'Not yet started'
    elsif project.over_budget?
      'Over budget'
    elsif completed_difference >= 0 # we're ahead of schedule
      ''
    else # we're behind schedule
      "Watch out"
    end
  end
end
