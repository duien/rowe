class SettingsController < ApplicationController
  def account
    @user = current_user
  end

  def update_account
    if current_user.update_attributes(params[:user])
      flash[:notice] = "Account settings updated"
      redirect_to account_settings_path
    else
      flash[:error] = "Settings could not be updated"
      render :account
    end
  end

  def projects
    @user = current_user

    if @user.freckle_set_up?
      @freckle_projects = Freckle::Project.all
      f_user = Freckle::User.by_email(@user.freckle_email)
      user_project_ids = f_user.entries(:from => Date.today.at_beginning_of_month.to_s).map(&:project_id)
      @projects_for_js = @freckle_projects.select{ |p| p.enabled or user_project_ids.include? p.id }.map{ |p| { :label => p.name, :id => p.id, :budget => p.budget.present? ? p.budget / 60 : '', :billable => p.billable } }
    end
  end

  def update_projects
    month = params[:month].inject({}){ |res, (k,v)| res.update( k => v.blank? ? nil : v ) }
    if current_user.current_month.update_attributes(month)
      flash[:notice] = "Projects updated"
      redirect_to projects_settings_path
    else
      flash[:error] = "Projects could not be updated"
      render :projects
    end
  end

  def vacation
    @user = current_user
  end

  def update_vacation
    month = if params[:month].present?
              params[:month].inject({}){ |res, (k,v)| res.update( k => v.blank? ? nil : v ) }
            else
              { :vacation_days => [] }
            end

    if current_user.current_month.update_attributes(month)
      flash[:notice] = "Vacation updated"
      redirect_to vacation_settings_path
    else
      flash[:error] = "Vacation could not be updated"
      render :vacation
    end
  end

end
