# Assuming today is 28 March 2011
Factory.define :needs_catchup_project, :class => Project do |f|
  f.name "Needs Catchup"
  f.billable true
  f.hours({ "dontcare" => 126.75 })
  f.budget 147.20
  f.start_day Date.civil(2011, 03, 01)
  f.end_day Date.civil(2011, 03, 31)
end

