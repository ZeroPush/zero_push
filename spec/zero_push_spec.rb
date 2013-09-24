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
end
