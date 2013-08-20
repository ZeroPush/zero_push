require 'spec_helper'
require 'json'

describe ZeroPush do
  before do
    ZeroPush.auth_token = ENV["AUTH_TOKEN"] || "test_token"
  end

  describe ".client" do

    let(:client){ZeroPush.client}

    it "should return a Faraday client" do
      client.class.must_equal Faraday::Connection
    end
  end

  describe ".verify_credentials" do
    before do
      VCR.insert_cassette "verify_credentials"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){ZeroPush.verify_credentials}

    it "should verify credentials successfully" do
      response.must_equal true
    end

    it "should fail to verify credentials" do
      ZeroPush.auth_token = "not a valid token"
      response.must_equal false
    end
  end

  describe ".notify" do
    before do
      VCR.insert_cassette "notify"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){ZeroPush.notify(device_tokens: ['abc'], alert: 'hi')}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a response with a body that can be parsed into a Hash" do
      JSON.parse(response.body).class.must_equal Hash
    end

    it "should be successful" do
      response.status.must_equal 200
    end
  end

  describe ".register" do
    before do
      VCR.insert_cassette "register"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){ZeroPush.register('abc')}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a response with a body that can be parsed into a Hash" do
      JSON.parse(response.body).class.must_equal Hash
    end

    it "should register the device" do
      response.status.must_equal 200
    end
  end

  describe ".set_badge" do
    before do
      VCR.insert_cassette "set_badge"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){ZeroPush.set_badge('abc', 10)}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a response with a body that can be parsed into a Hash" do
      JSON.parse(response.body).class.must_equal Hash
    end

    it "should set the device's badge" do
      response.status.must_equal 200
    end
  end

  describe ".inactive_tokens" do
    before do
      VCR.insert_cassette "inactive_tokens"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){ZeroPush.inactive_tokens}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a response with a body that can be parsed into an Array" do
      JSON.parse(response.body).class.must_equal Array
    end

    it "should get a list of inactive tokens" do
      response.status.must_equal 200
    end
  end
end
