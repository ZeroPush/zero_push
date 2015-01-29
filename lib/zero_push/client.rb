require 'zero_push/compatibility'
require 'faraday_middleware'

module ZeroPush
  class Client
    URL = 'https://api.zeropush.com'.freeze

    attr_accessor :auth_token

    def initialize(auth_token)
      self.auth_token = auth_token
      self.extend(Compatibility)
    end

    # verifies credentials
    #
    # @return [Boolean]
    def verify_credentials
      response = http.get('/verify_credentials')
      response.status == 200
    end

    # Sends a notification to the list of devices
    #
    # @param params [Hash]
    #
    # Ex.
    # {"sent_count":10,"inactive_tokens":[],"unregistered_tokens":["abc"]}
    def notify(params)
      http.post('/notify', params)
    end

    # Sends a notification to all of the devices registered with the ZeroPush backend
    #
    # @param params [Hash]
    #
    # Ex.
    # {"sent_count":10}
    def broadcast(params)
      http.post('/broadcast', params)
    end

    # Subscribes a device to a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Ex.
    # {"device_token":"abc", "channels":["foo"]}
    def subscribe(device_token, channel)
      http.post("/subscribe/#{channel}", device_token:device_token)
    end

    # Unsubscribes a device from a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Ex.
    # {"device_token":"abc", "channels":[]}
    def unsubscribe(device_token, channel)
      http.delete("/subscribe/#{channel}", device_token:device_token)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    #
    # Ex.
    # {"message":"ok"}
    def register(device_token, channel=nil)
      params = {device_token: device_token}
      params.merge!(channel: channel) unless channel.nil?
      http.post('/register', params)
    end

    # Unregisters a device token that has previously been registered with
    # ZeroPush
    #
    # @param device_token
    #
    # Ex.
    # {"message":"ok"}
    def unregister(device_token)
      http.delete('/unregister', device_token: device_token)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    #
    # Ex.
    # {"message":"ok"}
    def set_badge(device_token, badge)
      http.post('/set_badge', device_token: device_token, badge: badge)
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
    def inactive_tokens(params = {page:1})
      http.get('/inactive_tokens', params)
    end

    def devices(params = {page:1})
      http.get('/devices', params)
    end

    def device(token)
      http.get("/devices/#{token}")
    end

    def channels(params = {page:1})
      http.get('/channels', params)
    end

    def channel(channel_name)
      http.get("/channels/#{channel_name}")
    end

    def delete_channel(channel_name)
      http.delete("/channels/#{channel_name}")
    end

    def http
      Faraday.new(url: URL) do |c|
        c.token_auth self.auth_token
        c.request    http_config[:request_encoding]
        c.response   :json, :content_type => /\bjson$/ # parse responses to JSON
        c.adapter    http_config[:http_adapter]
      end
    end
    alias client http

    protected
      def http_config
        @http_config ||= ZeroPush.config.dup
      end
  end
end
