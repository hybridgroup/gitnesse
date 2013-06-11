# -*- encoding: utf-8 -*-
require File.expand_path '../lib/gitnesse/version', __FILE__

Gem::Specification.new do |spec|
  spec.name          = "gitnesse"
  spec.version       = Gitnesse::VERSION
  spec.authors       = ["www.hybridgroup.com"]
  spec.email         = ["info@hybridgroup.com"]
  spec.description   = %q{Use github wiki to store feature stories, then execute
                          then using Cucumber}
  spec.summary       = %q{Features on git-based Wiki!}
  spec.homepage      = "https://github.com/hybridgroup/gitnesse"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "gollum","~> 2.4.13"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 2.13.0"
  spec.add_development_dependency "cucumber", "~> 1.2.5"
end
