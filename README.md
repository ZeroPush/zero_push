[![ZeroPush](https://raw.github.com/ZeroPush/zero_push/master/zeropush-header.png)](https://zeropush.com)

[![Build Status](http://img.shields.io/travis/ZeroPush/zero_push.svg)](https://travis-ci.org/ZeroPush/zero_push) [![Code Climate](https://codeclimate.com/github/ZeroPush/zero_push/badges/gpa.svg)](https://codeclimate.com/github/ZeroPush/zero_push) [![Gem Version](http://img.shields.io/gem/v/zero_push.svg)](http://rubygems.org/gems/zero_push)

## Installation

Add this line to your application's Gemfile:

    gem 'zero_push'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zero_push

## Usage

### Rails Generator
Generate the ZeroPush initializer if you are using Ruby on Rails.

    $ rails g zero_push:install

### API Client

The easiest way to use the API client is to set the server `auth_token` at the module level and call methods on the ZeroPush module. You can find the token on settings page for your app.

```ruby
  ZeroPush.auth_token = 'iosprod_your-server-token'
  ZeroPush.notify(device_tokens: ['abcdef'], alert: 'hello, world', badge: '+1', info: {user_id: 1234})
```

If your web application supports must support multiple mobile apps, you may configure it like this:

```ruby
  if Rails.env == 'development'  #or ENV['RACK_ENV']
    ZeroPush.auth_tokens = {
      apns: 'iosdev_XYZ',
      gcm: 'gcmdev_ABC',
    }
  else
    ZeroPush.auth_tokens = {
      apns: 'iosprod_XYZ',
      gcm: 'gcmprod_ABC',
    }
  end
```

You may then instantiate clients by calling the method that matches the auth token key:

```ruby
  ZeroPush.apns.broadcast( ... )
  ZeroPush.gcm.broadcast( ... )
```


Lastly, if you have many apps you may instantiate clients API Clients

```ruby
  client_1 = ZeroPush.client('iosprod_app-server-token-1')
  client_1.broadcast(alert: 'hello, app1')

  client_2 = ZeroPush.client('iosprod_app-server-token-2')
  client_1.broadcast(alert: 'hello, app2')
```

Methods supported by this gem and their parameters can be found in the [API Reference](https://zeropush.com/documentation/api_reference)

For more documentation, check our [Getting Started Guide with ZeroPush](https://zeropush.com/documentation)

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write tests for your feature
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
