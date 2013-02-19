require "minitest/autorun"
require "zero_push"

class TestZeroPush < MiniTest::Unit::TestCase
  def setup
    ZeroPush.url = "https://test:password@testing.zeropush.com"
  end

  def test_should_respond_with_success
    ZeroPush.notify(alert: "hello device", device_tokens: ['123'])
  end

  def test_should_raise_an_exception
    ZeroPush.notify(alert: "hello device")
  end
end
