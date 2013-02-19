= zero_push

* Ruby client for ZeroPush (https://api.zeropush.com)

---

== DISCLAIMER:

This gem is not for use at this time.

== DESCRIPTION:

the zero_push integrates with your Rails/Rack apps to send push notifications to your users.

== FEATURES:

Supported API

* <tt>/notify</tt>

== SYNOPSIS:


  ZeroPush.notify(alert: 'Hello, iPhone', device_tokens: ['1234abc'])


== INSTALL:

  gem install zero_push

Configure for Heroku

in <tt>config/initializers/zero_push.rb</tt>:

  ZeroPush.url = ENV['ZERO_PUSH_URL']

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

== LICENSE:

(The MIT License)

Copyright (c) 2013 ZeroPush

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
