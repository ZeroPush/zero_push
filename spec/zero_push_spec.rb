require 'spec_helper'

#Faraday.default_adapter = :test

describe ZeroPush do
  before do
    VCR.insert_cassette "api"
    ZeroPush.url = "https://staging.zeropush.com"
    ZeroPush.auth_token = "acEJeDVC8if6XCxwe2js"
  end

  after do
    VCR.eject_cassette
  end

  describe "/notify" do
    it "should construct the request" do
      response = ZeroPush.notify(device_tokens: ['abc'], alert: 'hi')
      response.status.must_equal 200
    end
  end
end
