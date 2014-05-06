require 'zero_push/version'
require 'zero_push/client'
require 'faraday'

module ZeroPush
  class << self
    attr_accessor :auth_token

    def verify_credentials
      client.verify_credentials
    end

    def notify(params)
      client.notify(params)
    end

    def broadcast(params)
      client.broadcast(params)
    end

    def subscribe(device_token, channel)
      client.subscribe(device_token, channel)
    end

    def unsubscribe(device_token, channel)
      client.unsubscribe(device_token, channel)
    end

    def register(device_token, channel=nil)
      client.register(device_token, channel)
    end

    def unregister(device_token)
      client.unregister(device_token)
    end

    def set_badge(device_token, badge)
      client.set_badge(device_token, badge)
    end

    def inactive_tokens
      client.inactive_tokens
    end

    def client(auth_token = self.auth_token)
      ZeroPush::Client.new(auth_token)
    end
  end
end
