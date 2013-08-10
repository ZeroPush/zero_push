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
    # @return Hash
    #
    # Ex.
    # {"sent_count":0,"inactive_tokens":[],"unregistered_tokens":["abc"]}
    def notify(params)
      response = client.post('/notify', params)
      JSON.parse(response.body)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    # @return response
    #
    # Ex.
    # {"message":"ok"}
    def register(device_token)
      response = client.post('/register', device_token: device_token)
      JSON.parse(response.body)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    # @return response
    #
    # Ex.
    # {"message":"ok"}
    def set_badge(device_token, badge)
      response = client.post('/set_badge', device_token: device_token, badge: badge)
      JSON.parse(response.body)
    end

    # Returns a list of tokens that have been marked inactive
    #
    # @returns Array
    #
    # Ex.
    # [
    #   {
    #     "device_token":"238b8cb09011850cb4bd544dfe0c8f5eeab73d7eeaae9bdca59076db4ae49947",
    #     "marked_inactive_at":"2013-07-17T01:27:53-04:00"
    #   },
    #   {
    #     "device_token":"8c97be6643eea2143322005bc4c44a1aee5e549bce5e2bb2116114f45484ddaf",
    #     "marked_inactive_at":"2013-07-17T01:27:50-04:00"
    #   }
    # ]
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
