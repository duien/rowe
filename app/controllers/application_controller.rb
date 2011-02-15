class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :establish_freckle_connection

  protected

  def establish_freckle_connection
    if current_user.present? and current_user.freckle_set_up?
      Freckle.establish_connection( :account => current_user.freckle_account,
                                    :token => current_user.freckle_api_token
                                    )
    end
  end
end
