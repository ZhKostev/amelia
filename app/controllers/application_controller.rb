class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_access_token

  private

  def check_access_token
    redirect_to instagram_authorize_app_path unless instagram_session.token_set?
  end

  def instagram_session
    InstagramSession.new(session)
  end
end
