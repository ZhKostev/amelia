class InstagramSession
  SESSION_TOKEN_KEY = 'instagram_authorize_token'.freeze
  SESSION_ID_KEY = 'visitor_id'.freeze

  def initialize(app_session)
    @app_session = app_session
  end

  def token_set?
    token.present? && visitor_id.present?
  end

  def save_token(token)
    @app_session[SESSION_TOKEN_KEY] = token
    @app_session[SESSION_ID_KEY] = create_visitor(token).id
  end

  def token
    @app_session[SESSION_TOKEN_KEY]
  end

  def visitor_id
    @app_session[SESSION_ID_KEY]
  end

  private

  # :reek:UtilityFunction
  def create_visitor(token)
    Visitor.create!(instagram_token: token)
  end
end
