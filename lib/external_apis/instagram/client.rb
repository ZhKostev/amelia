module Instagram
  class Client
    include HTTParty
    base_uri 'api.instagram.com/v1'

    def initialize(access_token)
      @access_token = access_token
    end

    def tag_recent_media(tag_name)
      response = self.class.get("/tags/#{tag_name}/media/recent", query: { access_token: @access_token } )
      JSON.parse(response.body)
    end
  end
end
