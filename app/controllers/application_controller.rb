class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :establish_freckle_connection, :unless => :needs_to_set_up_freckle?

  protected

  def establish_freckle_connection
    if current_user.present? and current_user.freckle_set_up?
      Freckle.establish_connection( :account => current_user.freckle_account,
                                    :token => current_user.freckle_api_token
                                    )
    end
  end

  def ensure_freckle_set_up
    flash[:alert] = 'Please set up your user information first'
    redirect_to settings_path
  end

  def needs_to_set_up_freckle?
    # If you're not logged in, you don't need to set it up
    return false unless current_user

    !current_user.freckle_set_up?
  end


    
end
