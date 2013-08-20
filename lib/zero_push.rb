require 'faraday'
require 'zero_push/client'
require 'zero_push/version'

module ZeroPush
  URL = "https://api.zeropush.com"

  class << self
    attr_accessor :auth_token

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
      client.post('/notify', params)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    # @return response
    def register(device_token)
      client.post('/register', device_token: device_token)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    # @return response
    def set_badge(device_token, badge)
      client.post('/set_badge', device_token: device_token, badge: badge)
    end

    # Returns a list of tokens that have been marked inactive
    #
    # @returns array
    def inactive_tokens
      client.get('/inactive_tokens')
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
