require 'minitest/spec'
require 'minitest/autorun'
require 'zero_push'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :faraday
  c.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [:method, :uri, :headers]
  }
  #Note: in some cases it may be necessary to add
  #serialize_with: :syck to the default cassett options
  #when recording new cassettes
end
