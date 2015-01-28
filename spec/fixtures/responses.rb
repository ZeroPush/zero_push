class ZeroPush::Client
  def http
    Faraday.new do |builder|
      builder.token_auth self.auth_token
      builder.response :json, :content_type => /\bjson$/ # parse responses to JSON
      builder.adapter :test do |stub|
        stub.get('/verify_credentials') do |env|
          if env.request_headers['Authorization'] == "Token token=\"not a valid token\""
            [401, {'Content-Type' => 'application/json'}, '{"error": "unauthorized"}']
          else
            [200, {'Content-Type' => 'application/json'}, '{"message": "authenticated"}']
          end
        end
        stub.post('/register') { [200, {'Content-Type' => 'application/json'}, '{"message":"ok"}'] }
        stub.delete('/unregister') { [200, {'Content-Type' => 'application/json'}, '{"message":"ok"}'] }
        stub.post('/notify') { [200, {'Content-Type' => 'application/json'}, '{"sent_count":1, "inactive_tokens":[]}'] }
        stub.post('/broadcast') { [200, {'Content-Type' => 'application/json'}, '{"sent_count":10}'] }
        stub.post('/subscribe/foo_channel') { [200, {'Content-Type' => 'application/json'}, '{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","channels":["foo_channel"]}'] }
        stub.delete('/subscribe/foo_channel') { [200, {'Content-Type' => 'application/json'}, '{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","channels":[]}'] }
        stub.post('/set_badge') { [200, {'Content-Type' => 'application/json'}, '{"message":"ok"}'] }
        stub.get('/inactive_tokens') { [200, {'Content-Type' => 'application/json'}, '[{"device_token": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","marked_inactive_at": "2013-03-11T16:25:14-04:00"}]'] }
      end
    end
  end
end
