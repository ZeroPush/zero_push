require 'zero_push/version'
require 'faraday'

module ZeroPush
  URL = "http://www.zeropush.com"

  class << self
    attr_accessor :auth_token

    def notify(params)
      client.post('/api/notify', params)
    end

    def client
      Faraday.new(url: URL) do |c|
        c.token_auth  self.auth_token
        c.request     :url_encoded            # form-encode POST params
        c.adapter     Faraday.default_adapter # Net::HTTP
      end
    end
  end
end
