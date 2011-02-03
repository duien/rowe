class DashboardController < ApplicationController
  
  respond_to :html
  
  def index
    @month = current_user.current_month
    @month.update_hours if @month.last_update.blank? or @month.last_update < 5.minutes.ago
    if @month.projects.empty?
      render :no_projects
    else
      render :index
    end
  end

end
