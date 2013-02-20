# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zero_push/version'

Gem::Specification.new do |gem|
  gem.name          = "zero_push"
  gem.version       = ZeroPush::VERSION
  gem.authors       = ["Stefan Natchev", "Adam Duke"]
  gem.email         = ["stefan.natchev@gmail.com", "adam.v.duke@gmail.com"]
  gem.description   = %q{A gem to wrap the ZeroPush API}
  gem.summary       = %q{A gem to wrap the ZeroPush API}
  gem.homepage      = "https://github.com/ZeroPush/zero_push"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday"

  gem.add_development_dependency "minitest"
end
