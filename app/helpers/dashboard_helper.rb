module DashboardHelper
  def status_class(project)
    status_classes = []
    status_classes << 'over-budget' if project.over_budget?
    status_classes << 'ahead' if project.completed > should_have_done(project)
    status_classes << 'behind' if project.behind? and time_from_goal(project) > project.time_per_day
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

  def should_have_done(project)
    should = project.time_per_day * ( project.num_weekdays_elapsed )
    should += project.time_per_day if !project.ended? and Date.today.weekday?
    should
  end

  def time_from_goal(project)
    should_have_done(project) - project.completed
  end

  def status_text(project)
    if    time_from_goal(project) < 0   then 'ahead'
    else                                     'to go'
    end
  end

  def more_text(project)
    text = []
    text << "#{project.num_weekdays_remaining} days left" if project.started? and not project.ended?

    should_have_done = project.time_per_day * ( project.num_weekdays_elapsed ) 
    should_have_done += project.time_per_day if !project.ended? and Date.today.weekday? # include today for this calculation
    to_catch_up = should_have_done - project.completed

    if to_catch_up > 0
      text << %(<span class="catch-up">#{format_time to_catch_up} by end of day</span>)
    else
      ahead = -to_catch_up
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
