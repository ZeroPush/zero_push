require 'spec_helper'
require 'json'

describe ZeroPush::Client do

  let(:auth_token){ ENV['AUTH_TOKEN'] }
  let(:client){ ZeroPush.client(auth_token) }
  let(:device_token) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
  before do
    stub_request(:post, "https://api.zeropush.com/register").
      with(body: '{"device_token":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}', headers: {'Authorization'=>'Token token="test-token"', 'Content-Type'=>'application/json'}).
      to_return(status: 200, body: '{"message":"ok"}', headers: {'Content-Type' => 'application/json'})

    stub_request(:delete, "https://api.zeropush.com/unregister?device_token=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
      with(headers: {'Authorization'=>"Token token=\"#{auth_token}\""}).
      to_return(status: 200, body: '{"message":"ok"}', headers: {'Content-Type' => 'application/json'})
  end

  describe 'compatibility' do
    it 'should use url_encoding if `info` or `data` params are strings' do
      request = stub_request(:post, "https://api.zeropush.com/notify").
        with(body: {"info" => "{\"a\":1}"}, headers: {'Content-Type'=>'application/x-www-form-urlencoded'}).to_return(status: 200)
      client.notify(info: JSON.dump({a: 1}))
      assert_request_requested request
    end
    it 'should use JSON encoding if `info` or `data` params are hashes' do
      request = stub_request(:post, "https://api.zeropush.com/notify").
        with(body: '{"info":{"a":1}}', headers: {'Content-Type' => 'application/json'}).to_return(status: 200)
      client.notify(info: {a: 1})
      assert_request_requested request
    end
  end

  describe '#http' do
    it 'should instantiate a default http client' do
      client.http.must_be_instance_of Faraday::Connection
      client.http.headers['Authorization'].must_equal 'Token token="test-token"'
    end
  end

  describe '#verify_credentials' do
    it 'should verify credentials successfully' do
      stub_request(:get, "https://api.zeropush.com/verify_credentials").
        with(headers: {'Authorization'=>'Token token="test-token"'}).
        to_return(status: 200, body: '{"message": "authenticated"}', headers: {'Content-Type' => 'application/json'})

      client.verify_credentials.must_equal true
    end

    it 'should fail to verify credentials' do
      stub_request(:get, "https://api.zeropush.com/verify_credentials").
        with(headers: {'Authorization'=>'Token token="not a valid token"'}).
        to_return(status: 401, body: '{"error": "unauthorized"}', headers: {'Content-Type' => 'application/json'})

      client = ZeroPush.client('not a valid token')
      client.verify_credentials.must_equal false
    end
  end

  describe '#notify' do
    before do
      stub_request(:post, "https://api.zeropush.com/notify").
        with(body: '{"device_tokens":["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"],"alert":"hi"}').
        to_return(status: 200, body: '{"sent_count":1, "inactive_tokens":[], "unregistered_tokens":[]}', headers: {'Content-Type' => 'application/json'})
      client.register(device_token)
    end

    after do
      client.unregister(device_token)
    end

    let(:response){client.notify(device_tokens: [device_token], alert: 'hi')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should construct the request' do
      response.body['sent_count'].must_equal 1
      response.body['inactive_tokens'].must_equal []
    end
  end

  describe '#register' do
    describe 'without a channel parameter' do
      it 'should return a hash' do
        client.register(device_token).body.class.must_equal Hash
      end

      it 'should register the device' do
        client.register(device_token).body['message'].must_equal 'ok'
      end
    end

    describe 'with a channel parameter' do
      before do
        stub_request(:post, "https://api.zeropush.com/register").
          with(body: '{"device_token":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","channel":"foo"}',
               headers: {'Authorization'=>'Token token="test-token"', 'Content-Type'=>'application/json'}).
          to_return(status: 200, body: '{"message":"ok"}', headers: {'Content-Type'=>'application/json'})
      end
      it 'should return a hash' do
        client.register(device_token, 'foo').body.class.must_equal Hash
      end

      it 'should register the device' do
        client.register(device_token, 'foo').body['message'].must_equal 'ok'
      end
    end
  end

  describe '#unregister' do
    before do
      client.register(device_token)
    end

    describe 'when the device has been registered' do
      before do
        stub_request(:delete, "https://api.zeropush.com/unregister?device_token=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
          to_return(status: 200, body: '{"message":"ok"}', headers: {'Content-Type' => 'application/json'})
      end

      it 'should return a hash' do
        client.unregister(device_token).body.class.must_equal Hash
      end

      it 'should unregister the device' do
        client.unregister(device_token).body['message'].must_equal 'ok'
      end
    end
  end

  describe '#subscribe' do
    before do
      stub_request(:post, "https://api.zeropush.com/subscribe/foo_channel").
        with(body: '{"device_token":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}').
        to_return(status: 200, body: '{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","channels":["foo_channel"]}', headers: {'Content-Type' => 'application/json'})
    end

    let(:response){client.subscribe(device_token, 'foo_channel')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should subscribe a device to a channel' do
      response.body['device_token'].must_equal device_token
      response.body['channels'].must_include 'foo_channel'
    end
  end

  describe '#unsubscribe' do
    before do
      stub_request(:delete, "https://api.zeropush.com/subscribe/foo_channel?device_token=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
        to_return(status: 200, body: '{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","channels":[]}', headers: {'Content-Type' => 'application/json'})
    end

    let(:response){client.unsubscribe(device_token, 'foo_channel')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should subscribe a device to a channel' do
      response.body['device_token'].must_equal device_token
      response.body['channels'].wont_include 'foo_channel'
    end
  end

  describe '#broadcast' do
    before do
      stub_request(:post, "https://api.zeropush.com/broadcast").
        with(body: '{"alert":"hi"}').
        to_return(status: 200, body: '{"sent_count":10}', headers: {'Content-Type' => 'application/json'})
    end
    let(:response){client.broadcast(alert:'hi')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should broadcast a notification to all the devices' do
      response.body['sent_count'].must_equal 10
    end

    it 'should use json encoding for custom data' do
      request = stub_request(:post, "https://api.zeropush.com/broadcast").
        with(body: '{"data":{"alert":"hi","user_id":5}}', headers: {'Content-Type'=>'application/json'}).to_return(status: 200)
      client.broadcast(data: {alert: "hi", user_id: 5})
      assert_request_requested request
    end
  end

  describe '#set_badge' do
    before do
      stub_request(:post, "https://api.zeropush.com/set_badge").
        with(body: '{"device_token":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","badge":10}').
        to_return(status: 200, body: '{"message":"ok"}', headers: {'Content-Type'=>'application/json'})
    end

    let(:response){client.set_badge(device_token, 10)}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should set the device\'s badge' do
      response.body['message'].must_equal 'ok'
    end
  end

  describe '#inactive_tokens' do

    let(:response){client.inactive_tokens}
    before do
      stub_request(:get, "https://api.zeropush.com/inactive_tokens?page=1").
        to_return(status: 200, body: '[{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","marked_inactive_at": "2013-03-11T16:25:14-04:00"}]', headers: {'Content-Type'=>'application/json'})
    end

    it 'should return an array' do
      response.body.class.must_equal Array
    end

    it 'should get a list of inactive tokens' do
      response.body.count.must_equal 1
    end
  end

  describe '#devices' do
    let(:response){client.devices}
    before do
      stub_request(:get, "https://api.zeropush.com/devices?page=1").
        to_return(status: 200, body: '[]', headers: {'Content-Type' => 'application/json', 'Link' => '<https://api.zeropush.com/devices?page=10&per_page=25>; rel="last",<https://api.zeropush.com/devices?page=2&per_page=25>; rel="next"'})
    end
    it 'should return an array' do
      response.body.class.must_equal Array
    end
    it 'should have paginated results' do
      response.headers["link"].must_equal '<https://api.zeropush.com/devices?page=10&per_page=25>; rel="last",<https://api.zeropush.com/devices?page=2&per_page=25>; rel="next"'
    end
  end

  describe '#device' do
    before do
      stub_request(:get, "https://api.zeropush.com/devices/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
        to_return(status: 200, body: '{
  "token": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf",
  "active": true,
  "marked_inactive_at": null,
  "badge": 1,
  "channels": [
    "testflight",
    "user@example.com"
  ]
}', headers: {'Content-Type'=>'application/json'})
    end
    let(:response){client.device('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')}

    it 'should return a device hash' do
      response.body.class.must_equal Hash
      response.body.keys.must_equal %w[token active marked_inactive_at badge channels]
    end
  end

  describe '#channels' do
    before do
      stub_request(:get, "https://api.zeropush.com/channels?page=1").
        to_return(status: 200, body: '["player-1","foobar"]', headers: {'Content-Type'=>'application/json', 'Link' => '<https://api.zeropush.com/channels?page=10&per_page=25>; rel="last",<https://api.zeropush.com/channels?page=2&per_page=25>; rel="next"'})
    end
    let(:response){client.channels}
    it 'should return an array' do
      response.body.class.must_equal Array
    end
    it 'should have paginated results' do
      response.headers["link"].must_equal '<https://api.zeropush.com/channels?page=10&per_page=25>; rel="last",<https://api.zeropush.com/channels?page=2&per_page=25>; rel="next"'
    end
  end

  describe '#channel' do
    before do
      stub_request(:get, 'https://api.zeropush.com/channels/player-1').
        to_return(status: 200, body:'{
  "channel": "player-1",
  "device_tokens": [
    "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf"
  ]
}', headers: {'Content-Type' => 'application/json'})
    end

    let(:response) { client.channel('player-1') }

    it 'should return a channel hash' do
      response.body.class.must_equal Hash
      response.body.keys.must_equal %w[channel device_tokens]
    end
  end

  describe '#delete_channel' do
    before do
      stub_request(:delete, 'https://api.zeropush.com/channels/player-1').
        to_return(status: 200, body:'{
  "channel": "player-1",
  "device_tokens": [
    "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcedf"
  ]
}', headers: {'Content-Type' => 'application/json'})
    end

    let(:response) { client.delete_channel('player-1') }

    it 'should return a channel hash' do
      response.body.class.must_equal Hash
      response.body.keys.must_equal %w[channel device_tokens]
    end
  end
end
