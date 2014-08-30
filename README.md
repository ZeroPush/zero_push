[![ZeroPush](https://raw.github.com/ZeroPush/zero_push/master/zeropush-header.png)](https://zeropush.com)

Build Status: [![Build Status](https://travis-ci.org/ZeroPush/zero_push.png?branch=master)](https://travis-ci.org/ZeroPush/zero_push)

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

    ZeroPush.auth_token = 'server-token'
    ZeroPush.verify_credentials
    => true

If your application requires multiple API client instances, that can be achieved as well.

    client_1 = ZeroPush.client('server-token-1')
    client_1.verify_credentials
    => true

    client_2 = ZeroPush.client('server-token-2')
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

## License

Copyright (c) 2014 Symmetric Infinity LLC

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

