require 'zero_push/compatibility'
require 'faraday_middleware'

module ZeroPush
  class Client
    URL = 'https://zeropush.pushwoosh.com'.freeze

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
    # Example response
    # {"sent_count":10,"inactive_tokens":[],"unregistered_tokens":["abc"]}
    def notify(params)
      http.post('/notify', params)
    end

    # Sends a notification to all of the devices registered with the ZeroPush backend
    #
    # @param params [Hash]
    #
    # Example response
    # {"sent_count":10}
    def broadcast(params)
      http.post('/broadcast', params)
    end

    # Subscribes a device to a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Example response
    # {"device_token":"abc", "channels":["foo"]}
    def subscribe(device_token, channel)
      http.post("/subscribe/#{channel}", device_token:device_token)
    end

    # Unsubscribes a device from a particular notification channel
    #
    # @param device_token [String]
    # @param channel      [String]
    #
    # Example response
    # {"device_token":"abc", "channels":[]}
    def unsubscribe(device_token, channel)
      http.delete("/subscribe/#{channel}", device_token:device_token)
    end

    # Registers a device token with the ZeroPush backend
    #
    # @param device_token
    #
    # Example response
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
    # Example response
    # {"message":"ok"}
    def unregister(device_token)
      http.delete('/unregister', device_token: device_token)
    end

    # Sets the badge for a particular device
    #
    # @param device_token
    # @param badge
    #
    # Example response
    # {"message":"ok"}
    def set_badge(device_token, badge)
      http.post('/set_badge', device_token: device_token, badge: badge)
    end

    # Returns a list of tokens that have been marked inactive
    #
    # Example response
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

    # Returns a paginated list of devices
    # https://zeropush.com/documentation/api_reference#devices_index
    #
    # Example response
    # [
    #   {
    #     "token": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf",
    #     "active": true,
    #     "marked_inactive_at": null,
    #     "badge": 1
    #   },
    #   {
    #     "token": "234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf0",
    #     "active": true,
    #     "marked_inactive_at": null,
    #     "badge": 2
    #   }
    # ]
    def devices(params = {page:1})
      http.get('/devices', params)
    end

    # Return detailed information about a device
    # https://zeropush.com/documentation/api_reference#devices_show
    #
    # Example response
    # {
    #   "token": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf",
    #   "active": true,
    #   "marked_inactive_at": null,
    #   "badge": 1,
    #   "channels": [
    #     "testflight",
    #     "user@example.com"
    #   ]
    # }
    def device(token)
      http.get("/devices/#{token}")
    end

    # Replace the channel subscriptions with a new set of channels. This will
    # remove all previous subscriptions of the device. If you want to append a
    # list of channels, use #update_device.
    # https://zeropush.com/documentation/api_reference#devices_update_put
    #
    # @param token        String  token identifying the device
    # @param channel_list String  Comma separated list of channels
    #
    # Example Request
    #
    # ZeroPush.set_device(token, channel_list: 'player-1, game-256')
    #
    # Example Response
    # {
    #   "token": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf",
    #   "active": true,
    #   "marked_inactive_at": null,
    #   "badge": 1,
    #   "channels": [
    #     "player-1",
    #     "game-256"
    #   ]
    # }
    def set_device(token, params)
      http.put("/devices/#{token}", params)
    end

    # Append the channel subscriptions with a set of new channels. If you want
    # to replace the list of channels, use #set_device.
    # https://zeropush.com/documentation/api_reference#devices_update_patch
    #
    # @param token        String  token identifying the device
    # @param channel_list String  Comma separated list of channels
    #
    # Example Request
    #
    # ZeroPush.update_device(token, channel_list: 'player-1, game-256')
    #
    # Example Response
    # {
    #   "token": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf",
    #   "active": true,
    #   "marked_inactive_at": null,
    #   "badge": 1,
    #   "channels": [
    #     "player-1",
    #     "game-256"
    #   ]
    # }
    def update_device(token, params)
      http.patch("/devices/#{token}", params)
    end

    # Returns paginated list of channels
    # https://zeropush.com/documentation/api_reference#channels_index
    #
    # Example Response:
    # [
    #   "player-1",
    #   "player-2",
    #   "player-9",
    #   "game-256",
    #   "admins",
    #   "lobby"
    # ]
    def channels(params = {page:1})
      http.get('/channels', params)
    end

    # Returns the list of device tokens for the given channel
    # https://zeropush.com/documentation/api_reference#channels_show
    #
    # Example Response:
    # {
    #   "channel": "player-1",
    #   "device_tokens": [
    #     "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf"
    #   ]
    # }
    def channel(channel_name)
      http.get("/channels/#{channel_name}")
    end

    # Deletes a channels and unsubscribes all of the devices from it.
    # https://zeropush.com/documentation/api_reference#channels_destroy
    #
    # {
    #   "channel": "player-1",
    #   "device_tokens": [
    #     "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf"
    #   ]
    # }
    def delete_channel(channel_name)
      http.delete("/channels/#{channel_name}")
    end

    # Instantiate a new http client configured for making requests to the API
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
