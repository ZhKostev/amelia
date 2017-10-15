module Front
  class InstagramController < ApplicationController
    skip_before_action :check_access_token
    before_action :redirect_to_home_if_token_set

    def log_in; end

    def authorize
      redirect_to instagram_client.auth_code.authorize_url(redirect_uri: instagram_callback_url)
    end

    def callback
      oauth_token = instagram_client.auth_code.get_token(params[:code], redirect_uri: instagram_callback_url)
      instagram_session.save_token(oauth_token.token)
      redirect_to root_path
    end

    private

    # :reek:UtilityFunction
    def instagram_client
      OAuth2::Client.new(ENV['INSTANGRAM_API_CLIENT_ID'], ENV['INSTANGRAM_API_CLIENT_SECRET'],
                         site: 'https://api.instagram.com',
                         authorize_url: 'https://api.instagram.com/oauth/authorize',
                         token_url: 'https://api.instagram.com/oauth/access_token')
    end

    def redirect_to_home_if_token_set
      redirect_to root_path if instagram_session.token_set?
    end
  end
end
