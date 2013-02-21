require 'spec_helper'

#Faraday.default_adapter = :test

describe ZeroPush do
  before do
    ZeroPush::URL = "https://staging.zeropush.com"
    ZeroPush.auth_token = "acEJeDVC8if6XCxwe2js"
  end

  describe "/notify" do
    before do
      VCR.insert_cassette "notify"
    end

    after do
      VCR.eject_cassette
    end

    it "should construct the request" do
      response = ZeroPush.notify(device_tokens: ['abc'], alert: 'hi')
      response.status.must_equal 200
    end
  end
end
