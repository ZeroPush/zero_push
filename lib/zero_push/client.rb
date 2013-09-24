require 'faraday_middleware'

module ZeroPush
  class Client
    URL = 'https://api.zeropush.com'.freeze

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
    #
    # Ex.
    # {"sent_count":10,"inactive_tokens":[],"unregistered_tokens":["abc"]}
    def notify(params)
      client.post('/notify', params)
    end

    # Sends a notification to all of the devices registered with the ZeroPush backend
    #
    # @param params [Hash]
    #
    # Ex.
    # {"sent_count":10}
    def broadcast(params)
      client.post('/broadcast', params)
    end

    # Subscribes a device to a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Ex.
    # {"device_token":"abc", "channels":["foo"]}
    def subscribe(device_token, channel)
      client.post("/subscribe/#{channel}", device_token:device_token)
    end

    # Unsubscribes a device from a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Ex.
    # {"device_token":"abc", "channels":[]}
    def unsubscribe(device_token, channel)
      client.delete("/subscribe/#{channel}", device_token:device_token)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    #
    # Ex.
    # {"message":"ok"}
    def register(device_token)
      client.post('/register', device_token: device_token)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    #
    # Ex.
    # {"message":"ok"}
    def set_badge(device_token, badge)
      client.post('/set_badge', device_token: device_token, badge: badge)
    end

    # Returns a list of tokens that have been marked inactive
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
      client.get('/inactive_tokens')
    end

    # the HTTP client configured for API requests
    #
    def client
      Faraday.new(url: URL) do |c|
        c.token_auth self.auth_token
        c.request    :url_encoded            # form-encode POST params
        c.response   :json, :content_type => /\bjson$/ # parse responses to JSON
        c.adapter    Faraday.default_adapter # Net::HTTP
      end
    end
  end
end
