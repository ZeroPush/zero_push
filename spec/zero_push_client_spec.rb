require 'spec_helper'

describe ZeroPush::Client do

  let(:auth_token){ENV["AUTH_TOKEN"] || "test_token"}
  let(:verified_client){ZeroPush::Client.new(auth_token)}
  let(:unverified_client){ZeroPush::Client.new("not a valid token")}

  describe "#verify_credentials" do
    before do
      VCR.insert_cassette "verify_credentials"
    end

    after do
      VCR.eject_cassette
    end

    describe "for a verified client" do
      let(:response){verified_client.verify_credentials}

      it "should verify credentials successfully" do
        response.must_equal true
      end
    end

    describe "for an unverified client" do
      let(:response){unverified_client.verify_credentials}

      it "should fail to verify credentials" do
        response.must_equal false
      end
    end
  end

  describe "#notify" do
    before do
      VCR.insert_cassette "notify"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){verified_client.notify(device_tokens: ['abc'], alert: 'hi')}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a Hash for a response body" do
      response.body.class.must_equal Hash
    end

    it "should be successful" do
      response.status.must_equal 200
    end
  end

  describe "#register" do
    before do
      VCR.insert_cassette "register"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){verified_client.register('abc')}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a Hash for a response body" do
      response.body.class.must_equal Hash
    end

    it "should register the device" do
      response.status.must_equal 200
    end
  end

  describe "#set_badge" do
    before do
      VCR.insert_cassette "set_badge"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){verified_client.set_badge('abc', 10)}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return a Hash for a response body" do
      response.body.class.must_equal Hash
    end

    it "should set the device's badge" do
      response.status.must_equal 200
    end
  end

  describe "#inactive_tokens" do
    before do
      VCR.insert_cassette "inactive_tokens"
    end

    after do
      VCR.eject_cassette
    end

    let(:response){verified_client.inactive_tokens}

    it "should return a Faraday::Response" do
      response.class.must_equal Faraday::Response
    end

    it "should return an Array for a response body" do
      response.body.class.must_equal Array
    end

    it "should get a list of inactive tokens" do
      response.status.must_equal 200
    end
  end
end
