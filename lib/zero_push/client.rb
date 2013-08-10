require 'json'

module ZeroPush
  class Client
    URL = "https://api.zeropush.com"

    attr_accessor :auth_token

    def initialize(auth_token)
      self.auth_token = auth_token
    end

    # verifies credentials
    #
    # @return [Boolean]
    def verify_credentials
      response = client.get('/verify_credentials')
      response.status == 200
    end

    # Sends a notification to the list of devices
    #
    # @param params [Hash]
    # @return response
    def notify(params)
      response = client.post('/notify', params)
      JSON.parse(response.body)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    # @return response
    def register(device_token)
      response = client.post('/register', device_token: device_token)
      JSON.parse(response.body)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    # @return response
    def set_badge(device_token, badge)
      response = client.post('/set_badge', device_token: device_token, badge: badge)
      JSON.parse(response.body)
    end

    # Returns a list of tokens that have been marked inactive
    #
    # @returns array
    def inactive_tokens
      response = client.get('/inactive_tokens')
      JSON.parse(response.body)
    end

    # the HTTP client configured for API requests
    #
    def client
      Faraday.new(url: URL) do |c|
        c.token_auth  self.auth_token
        c.request     :url_encoded            # form-encode POST params
        c.adapter     Faraday.default_adapter # Net::HTTP
      end
    end
  end
end
