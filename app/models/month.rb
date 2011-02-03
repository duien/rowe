class Month
  include MongoMapper::Document         
  include ScheduleMath

  GRAPH_COLORS = %w(caa91e 3C7368 cd7c23 8f8b1d d9d58b)

  key :month, Date, :default => lambda{ Date.today.at_beginning_of_month }
  key :other, Project, :default => lambda{ Project.new(:name => 'Other') }
  key :last_update, Time

  belongs_to :user
  many :projects

  def completed
    self.projects.select{ |p| p.billable }.map(&:completed).inject(&:+)
  end

  def budget
    num_weekdays * 6.4
  end
  
  def start_day
    self.month.at_beginning_of_month
  end

  def end_day
    self.month.at_end_of_month
  end

  def update_hours
    raise unless self.user.freckle_set_up?
    Freckle.establish_connection( :account => user.freckle_account,
                                  :token => user.freckle_api_token
                                  )
    project_mapping = self.projects.inject({}){ |h,p| h.update( p.freckle_id => p ) }
    user = Freckle::User.by_login(self.user.freckle_user_name)
    projects.each{ |p| p.hours = {} }
    other.hours = {}
    entries = user.entries(:from => start_day.to_s, :to => end_day.to_s)
    entries.each do |entry|
      if project = project_mapping[entry.project_id]
        project.hours[entry.date] ||= 0
        project.hours[entry.date] += entry.minutes.to_f / 60
      else
        other.hours[entry.date] ||= 0
        other.hours[entry.date] += entry.minutes.to_f / 60
      end
    end
    self.last_update = Time.now
    self.save
  end

  def dates
    start_day..end_day
  end

  def chart_url
    google_chart_url = "http://chart.googleapis.com/chart?"
    google_chart_params = {
      # Chart type: bar vertical stacked
      :cht  => 'bvs',
      # Chart size
      :chs  => '940x300',
      # Chart data scale
      :chds => '0,12',
      # Chart markers : horizontal, color, series, which points (or placement), width, z-index
      :chm  => [
        'h,8f8b1d,0,0,1,-0.5',
        (1..12).map{ |i| "h,d6d182,0,#{i/12.0},1,-0.5" }
      ].flatten.join('|'),
      # Chart margin
      :chma => '10,10,10,10',
      # Chart bar width: automatic
      :chbh => 'a',
      # Chart axis style: axis, label_color, label_size, alignment, line or tick, tick color
      :chxs => '0,8f8b1d,11,0,t,8f8b1d|1,8f8b1d,11,0,t,d6d182|2,100f0e,11,0,t,100f0e',
      # Chart fill: area, type, color
      :chf => 'bg,s,e6e3b200',
      # Chart axis range: axis, start, end, step
      :chxr => '1,0,12,2',
      # Chart axis tick style: axis, length
      :chxtc => '2,-800',
      # Chart axis label positions: axis, position
      :chxp => [2, (6.4/12)*100].join(','),
      # Chart colors
      :chco => [ GRAPH_COLORS.first(projects.length), %w(e6e3b200 d15028)].flatten.join(','),
      # extra light blue: 76b8ab
      # Chart axes
      :chxt => 'x,y,r',
      # Chart axis labels : axis, labels
      :chxl => [ '0:', dates.map{ |d| d.day }, '2:', 'target' ].flatten.join('|'),
      # Chart data labels
      :chdl => [ projects.map{ |p| p.name }, '', 'Other' ].flatten.join('|'),
      # Chart data
      :chd  => 't:' + [
        projects.map{ |project| dates.map{ |date| project.hours[date.to_s] || 0 }.join(',') },
        dates.map{ '_' }.join(','),
        dates.map{ |date| other.hours[date.to_s] || 0 }.join(',')
      ].flatten.join('|')
    }

    google_chart_url + google_chart_params.inject([]){ |r,(k,v)| r << "#{k}=#{v}" }.join('&')
  end




    
# Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# validates_presence_of :attribute

# Assocations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# belongs_to :model
# many :model
# one :model

# Callbacks ::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# before_create :your_model_method
# after_create :your_model_method
# before_update :your_model_method 

# Attribute options extras ::::::::::::::::::::::::::::::::::::::::
# attr_accessible :first_name, :last_name, :email

# Validations
# key :name, :required =>  true      

# Defaults
# key :done, :default => false

# Typecast
# key :user_ids, Array, :typecast => 'ObjectId'
  
   
end
