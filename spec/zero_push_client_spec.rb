require 'spec_helper'

describe ZeroPush::Client do
  before do
    auth_token = ENV["AUTH_TOKEN"] || "test_token"
    @client = ZeroPush.client(auth_token)
  end

  describe "#verify_credentials" do
    before do
      VCR.insert_cassette "verify_credentials"
    end

    after do
      VCR.eject_cassette
    end

    it "should verify credentials successfully" do
      @client.verify_credentials.must_equal true
    end

    it "should fail to verify credentials" do
      @client = ZeroPush.client("not a valid token")
      @client.verify_credentials.must_equal false
    end
  end

  describe "#notify" do
    before do
      VCR.insert_cassette "notify"
    end

    after do
      VCR.eject_cassette
    end

    it "should return a hash" do
      response = @client.notify(device_tokens: ['abc'], alert: 'hi')
      response.body.class.must_equal Hash
    end

    it "should construct the request" do
      response = @client.notify(device_tokens: ['abc'], alert: 'hi')
      response.body['sent_count'].must_equal 0
      response.body['inactive_tokens'].must_equal []
    end
  end

  describe "#register" do
    before do
      VCR.insert_cassette "register"
    end

    after do
      VCR.eject_cassette
    end

    it "should return a hash" do
      response = @client.register('abc')
      response.body.class.must_equal Hash
    end

    it "should register the device" do
      response = @client.register('abc')
      response.body['message'].must_equal 'ok'
    end
  end

  describe "#set_badge" do
    before do
      VCR.insert_cassette "set_badge"
    end

    after do
      VCR.eject_cassette
    end

    it "should return a hash" do
      response = @client.set_badge('abc', 10)
      response.body.class.must_equal Hash
    end

    it "should set the device's badge" do
      response = @client.set_badge('abc', 10)
      response.body['message'].must_equal 'ok'
    end
  end

  describe "#inactive_tokens" do
    before do
      VCR.insert_cassette "inactive_tokens"
    end

    after do
      VCR.eject_cassette
    end

    it "should return an array" do
      response = @client.inactive_tokens
      response.body.class.must_equal Array
    end

    it "should get a list of inactive tokens" do
      response = @client.inactive_tokens
      response.body.count.must_equal 2
    end
  end
end
