require 'spec_helper'

device_token = 64.times.collect { Random.rand(16).to_s(16) }.join

describe ZeroPush::Client do

  let(:auth_token){ENV['AUTH_TOKEN'] || 'test_token'}
  let(:client){ZeroPush.client(auth_token)}

  describe '#verify_credentials' do

    it 'should verify credentials successfully' do
      client.verify_credentials.must_equal true
    end

    it 'should fail to verify credentials' do
      client = ZeroPush.client('not a valid token')
      client.verify_credentials.must_equal false
    end
  end

  describe '#notify' do
    before do
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
      client.register(device_token)
    end

    after do
      client.unregister(device_token)
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
      client.register(device_token)
      client.subscribe(device_token, 'foo_channel')
    end

    after do
      client.unregister(device_token)
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
    let(:response){client.broadcast(alert:'hi')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should broadcast a notification to all the devices' do
      response.body['sent_count'].must_equal 10
    end
  end

  describe '#set_badge' do
    before do
      client.register(device_token)
    end

    after do
      client.unregister(device_token)
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

    it 'should return an array' do
      response.body.class.must_equal Array
    end

    it 'should get a list of inactive tokens' do
      response.body.count.must_equal 2
    end
  end
end
