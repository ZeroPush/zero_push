require 'spec_helper'

#Faraday.default_adapter = :test

describe ZeroPush do
  before do
    VCR.insert_cassette "api"
    ZeroPush.url = "https://staging.zeropush.com"
    ZeroPush.auth_token = "ULaBg3oBxdMzop2bqArA"
  end

  after do
    VCR.eject_cassette
  end

  describe "/notify" do
    it "should construct the request" do
      request = ZeroPush.notify(device_tokens: ['abc'], alert: 'hi')
    end
  end
end
