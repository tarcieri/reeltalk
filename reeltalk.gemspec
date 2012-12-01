# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reeltalk/version'

Gem::Specification.new do |gem|
  gem.name          = "reeltalk"
  gem.version       = Reeltalk::VERSION
  gem.authors       = ["Tony Arcieri"]
  gem.email         = ["tony.arcieri@gmail.com"]
  gem.description   = "Web chat system using Celluloid+Reel+Websockets"
  gem.summary       = "Reel is a realtime websockets-based chat system built using Celluloid and the Reel web server"
  gem.homepage      = "https://github.com/tarcieri/reeltalk"

  gem.add_runtime_dependency 'reel'
  gem.add_runtime_dependency 'json'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
