# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zero_push/version'

Gem::Specification.new do |gem|
  gem.name          = "zero_push"
  gem.version       = ZeroPush::VERSION
  gem.authors       = ["Stefan Natchev", "Adam Duke"]
  gem.email         = ["stefan.natchev@gmail.com", "adam.v.duke@gmail.com"]
  gem.summary       = %q{A gem for interacting with the ZeroPush API. (http://zeropush.com)}
  gem.description   = %q{ZeroPush is a simple service for sending iOS push notifications. (http://zeropush.com)}
  gem.homepage      = "https://zeropush.com"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9'

  gem.add_dependency "faraday", "~> 0.8.5"
  gem.add_dependency "faraday_middleware", "~> 0.9.0"

  gem.add_development_dependency 'actionpack',    '~> 3.2.11'
  gem.add_development_dependency 'activesupport', '~> 3.2.11'
  gem.add_development_dependency 'minitest',      '~> 4.7.0'
  gem.add_development_dependency 'mocha',         '~> 0.13.3'
  gem.add_development_dependency 'rake',          '~> 10.0.3'
  gem.add_development_dependency 'railties',      '~> 3.2.11'
  gem.add_development_dependency 'vcr',           '~> 2.4.0'
end
