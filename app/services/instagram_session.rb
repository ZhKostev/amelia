class InstagramSession
  SESSION_TOKEN_KEY = 'instagram_authorize_token'
  SESSION_ID_KEY = 'visitor_id'

  class << self
    def token_set?(session)
      session[SESSION_TOKEN_KEY].present? && session[SESSION_ID_KEY].present?
    end

    # :reek:FeatureEnvy
    def set_token(session, token)
      session[SESSION_TOKEN_KEY] = token
      session[SESSION_ID_KEY] = create_visitor(token).id
    end

    private

    def create_visitor(token)
      Visitor.create!(instagram_token: token)
    end
  end
end