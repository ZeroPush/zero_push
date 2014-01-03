require 'spec_helper'

describe ZeroPush do
  before do
    ZeroPush.auth_token = ENV['AUTH_TOKEN'] || 'test_token'
  end

  describe '.client' do
    it 'should return a client instance' do
      ZeroPush.client.class.must_equal ZeroPush::Client
    end
  end

  describe 'methods the module responds to' do
    [:verify_credentials, :notify, :broadcast, :register, :set_badge, :inactive_tokens, :client].each do |method|
      it "should respond to #{method}" do
        ZeroPush.respond_to?(method).must_equal(true)
      end
    end
  end
end
