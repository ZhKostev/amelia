class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :apply_demo_token_if_needed
  before_action :check_access_token

  private

  def apply_demo_token_if_needed
    instagram_session.save_token(Visitor.first.try(:instagram_token)) if params[:demo_user]
  end

  def check_access_token
    redirect_to instagram_authorize_app_path unless instagram_session.token_set?
  end

  def instagram_session
    InstagramSession.new(session)
  end
end
