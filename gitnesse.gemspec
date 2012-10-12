# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitnesse/version'

Gem::Specification.new do |gem|
  gem.name          = "gitnesse"
  gem.version       = Gitnesse::VERSION
  gem.authors       = ["www.hybridgroup.com"]
  gem.email         = ["info@hybridgroup.com"]
  gem.description   = %q{Use github wiki to store feature stories, then execute then using Cucumber}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/hybridgroup/gitnesse"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "gollum"
end
