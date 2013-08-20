require 'faraday_middleware'

module ZeroPush
  class Client

    def initialize(auth_token)
      @faraday = Faraday.new(url: ZeroPush::URL) do |c|
        c.token_auth auth_token                        # Set the Authorization header
        c.request    :url_encoded                      # form-encode POST params
        c.response   :json, :content_type => /\bjson$/ # parse responses to JSON
        c.adapter    Faraday.default_adapter           # Net::HTTP
      end
    end

    def verify_credentials
      response = faraday.get('/verify_credentials')
      response.status == 200
    end

    def notify(params)
      faraday.post('/notify', params)
    end

    def register(device_token)
      faraday.post('/register', device_token: device_token)
    end

    def set_badge(device_token, badge)
      faraday.post('/set_badge', device_token: device_token, badge: badge)
    end

    def inactive_tokens
      faraday.get('/inactive_tokens')
    end

    private
      attr_reader :faraday
  end
end
