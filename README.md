[![ZeroPush](https://raw.github.com/SymmetricInfinity/zero_push/master/zeropush-header.png)](https://zeropush.com)

Build Status: [![Build Status](https://travis-ci.org/SymmetricInfinity/zero_push.png?branch=master)](https://travis-ci.org/SymmetricInfinity/zero_push)

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

The easiest way to use the API client is to set the auth token at the module level and call methods on the ZeroPush module.

    ZeroPush.auth_token = 'your-auth-token'
    ZeroPush.verify_credentials
    => true

If your application requires multiple API client instances, that can be achieved as well.

    client_1 = ZeroPush.client('auth-token-1')
    client_1.verify_credentials
    => true

    client_2 = ZeroPush.client('auth-token-2')
    client_2.verify_credentials
    => true

For more documentation, check our [Getting Started Guide with ZeroPush](https://zeropush.com/documentation)

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write tests for your feature
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
