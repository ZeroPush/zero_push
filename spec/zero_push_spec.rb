require "minitest/spec"
require "minitest/autorun"
require "zero_push"

Faraday.default_adapter = :test

describe ZeroPush do
  before do
    ZeroPush.url = "https://staging.zeropush.com"
    ZeroPush.auth_token = "ULaBg3oBxdMzop2bqArA"
  end

  describe "/notify" do
    it "should construct the request" do
      request = ZeroPush.notify(device_tokens: ['abc'], alert: 'hi')
    end
  end
end
