require 'spec_helper'

describe ZeroPush do
  before do
    ZeroPush.auth_token = ENV["AUTH_TOKEN"] || "test_token"
  end

  describe "/verify_credentials" do
    before do
      VCR.insert_cassette "verify_credentials"
    end

    after do
      VCR.eject_cassette
    end

    it "should verify credentials successfully" do
      ZeroPush.verify_credentials.must_equal true
    end

    it "should fail to verify credentials" do
      ZeroPush.auth_token = "not a valid token"
      ZeroPush.verify_credentials.must_equal false
    end
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
