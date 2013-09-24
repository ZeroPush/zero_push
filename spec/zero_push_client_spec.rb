require 'spec_helper'

describe ZeroPush::Client do

  let(:auth_token){ENV['AUTH_TOKEN'] || 'test_token'}
  let(:client){ZeroPush.client(auth_token)}

  describe '#verify_credentials' do
    before do
      VCR.insert_cassette 'verify_credentials'
    end

    after do
      VCR.eject_cassette
    end

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
      VCR.insert_cassette 'notify'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.notify(device_tokens: ['abc'], alert: 'hi')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should construct the request' do
      response.body['sent_count'].must_equal 0
      response.body['inactive_tokens'].must_equal []
    end
  end

  describe '#register' do
    before do
      VCR.insert_cassette 'register'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.register('abc')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should register the device' do
      response.body['message'].must_equal 'ok'
    end
  end

  describe '#subscribe' do
    before do
      VCR.insert_cassette 'subscribe'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.subscribe('abc', 'foo_channel')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should subscribe a device to a channel' do
      response.body['device_token'].must_equal 'abc'
      response.body['channels'].must_equal ['foo_channel']
    end
  end

  describe '#unsubscribe' do
    before do
      VCR.insert_cassette 'unsubscribe'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.unsubscribe('abc', 'foo_channel')}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should subscribe a device to a channel' do
      response.body['device_token'].must_equal 'abc'
      response.body['channels'].must_equal []
    end
  end

  describe '#broadcast' do
    before do
      VCR.insert_cassette 'broadcast'
    end

    after do
      VCR.eject_cassette
    end

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
      VCR.insert_cassette 'set_badge'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.set_badge('abc', 10)}

    it 'should return a hash' do
      response.body.class.must_equal Hash
    end

    it 'should set the device\'s badge' do
      response.body['message'].must_equal 'ok'
    end
  end

  describe '#inactive_tokens' do
    before do
      VCR.insert_cassette 'inactive_tokens'
    end

    after do
      VCR.eject_cassette
    end

    let(:response){client.inactive_tokens}

    it 'should return an array' do
      response.body.class.must_equal Array
    end

    it 'should get a list of inactive tokens' do
      response.body.count.must_equal 2
    end
  end
end
