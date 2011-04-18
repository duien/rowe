# Assuming today is 28 March 2011
Factory.define :needs_catchup_project, :class => Project do |f|
  f.name "Needs Catchup"
  f.billable true
  f.hours({ "dontcare" => 126.75 })
  f.budget 147.20
  f.start_day Date.civil(2011, 03, 01)
  f.end_day Date.civil(2011, 03, 31)
end

# Assuming today is 28 March 2011
Factory.define :ahead_project, :class => Project do |f|
  f.name "Ahead of Schedule"
  f.billable true
  f.hours({ "dontcare" => 128.75 })
  f.budget 147.20
  f.start_day Date.civil(2011, 03, 01)
  f.end_day Date.civil(2011, 03, 31)
end

Factory.define :month_with_vacation, :class => Month do |f|
  f.month Date.civil(2011, 03, 01)
  f.vacation_days [ 21, 22, 23, 24, 25 ]
end

Factory.define :month_without_vacation, :class => Month do |f|
  f.month Date.civil(2011, 03, 01)
  f.vacation_days [ ]
end
