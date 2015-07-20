require 'spec_helper'

describe ZeroPush do
  before do
    ZeroPush.auth_token = ENV['AUTH_TOKEN'] || 'test_token'
  end

  describe 'using different auth_tokens' do
    it 'accepts a hash of tokens' do
      ZeroPush.auth_tokens = {
        apns: 'test-apns-token',
        gcm: 'test-gcm-token'
      }
      ZeroPush.apns.auth_token.must_equal 'test-apns-token'
      ZeroPush.gcm.auth_token.must_equal 'test-gcm-token'
    end
  end

  describe '.client' do
    it 'returns a client instance' do
      ZeroPush.client.class.must_equal ZeroPush::Client
    end
  end

  describe 'methods the module responds to' do
    [:verify_credentials, :notify, :broadcast, :subscribe, :unsubscribe, :register, :unregister, :set_badge, :inactive_tokens, :devices, :device, :set_device, :update_device, :channels, :channel, :delete_channel, :client].each do |method|
      it "responds to #{method}" do
        ZeroPush.respond_to?(method).must_equal(true)
      end
    end
  end
end
