require 'minitest/autorun'
require 'minitest/spec'
require 'zero_push'
require 'pry'

ENV['AUTH_TOKEN'] ||= 'test-token'

require 'fixtures/responses' if ENV['AUTH_TOKEN'] == 'test-token'
