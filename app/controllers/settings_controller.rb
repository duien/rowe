class SettingsController < ApplicationController
  def settings
    @user = current_user
    if @user.freckle_set_up?
      @freckle_projects = Freckle::Project.all
      f_user = Freckle::User.by_login(@user.freckle_user_name)
      user_project_ids = f_user.entries(:from => Date.today.at_beginning_of_month.to_s).map(&:project_id)
      @projects_for_js = @freckle_projects.select{ |p| p.enabled or user_project_ids.include? p.id }.map{ |p| { :label => p.name, :id => p.id, :budget => p.budget.present? ? p.budget / 60 : '', :billable => p.billable } }
    end
  end

  def update
    success = if    params[:user].present?  then current_user.update_attributes(params[:user])
              elsif params[:month].present?
                current_user.current_month.update_attributes(params[:month])
              end
    if success
      flash[:notice] = "Settings updated"
      redirect_to settings_path
    else
      flash[:error] = "Settings could not be updated"
      render :settings
    end
  end

end
