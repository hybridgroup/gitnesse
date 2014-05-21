# -*- encoding: utf-8 -*-
require File.expand_path '../lib/gitnesse/version', __FILE__

Gem::Specification.new do |spec|
  spec.name          = "gitnesse"
  spec.version       = Gitnesse::VERSION
  spec.authors       = ["www.hybridgroup.com"]
  spec.email         = ["info@hybridgroup.com"]
  spec.description   = %q{Gitnesse lets you sync Cucumber feature stories
                          through a Git-based wiki, and display current
                          scenario results on wiki pages}
  spec.summary       = %q{Sync your feature stories using a Git-based wiki!}
  spec.homepage      = "https://github.com/hybridgroup/gitnesse"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"
  spec.add_dependency "git", "1.2.6"
  spec.add_development_dependency "rake", "10.3.2"
  spec.add_development_dependency "rspec",   "2.14.1"
  spec.add_development_dependency "cucumber", "1.3.15"
end
