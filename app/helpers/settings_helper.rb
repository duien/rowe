module SettingsHelper
  def freckle_section_class(user)
    'hidden' if user.freckle_user_name? and user.freckle_account? and user.freckle_api_token?
  end
end
