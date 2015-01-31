require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'
require 'zero_push'
require 'pry'

ENV['AUTH_TOKEN'] ||= 'test-token'

WebMock.enable!
