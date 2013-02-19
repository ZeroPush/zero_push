require 'faraday'

module ZeroPush
  VERSION = "0.0.1"

  class << self
    attr_accessor :url

    def notify(params)
      client.post('/v1/notify', params)
    end

    def client
      Faraday.new(url: url) do |c|
        c.request :url_encoded            # form-encode POST params
        c.adapter Faraday.default_adapter # Net::HTTP
      end
    end
  end
end
