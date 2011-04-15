class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  # before_filter :establish_freckle_connection, :if => :user_signed_in?

  protected

  # def establish_freckle_connection
  #   current_user.establish_freckle_connection
  # end

  def ensure_freckle_set_up
    case current_user.establish_freckle_connection
    when :field_missing
      flash[:alert] = 'Please set up your Freckle account'
      redirect_to account_settings_path
    when :invalid_email
      flash[:alert] = 'No user found with Freckle email address'
      redirect_to account_settings_path
    when :invalid_api_token
      flash[:alert] = 'Invalid API token'
      redirect_to account_settings_path
    end
  end

end
