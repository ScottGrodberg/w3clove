# -*- encoding: utf-8 -*-
require File.expand_path('../lib/w3clove/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jaime Iniesta"]
  gem.email         = ["jaimeiniesta@gmail.com"]
  gem.description   = %q{this tool allows you to check the markup validation of a whole site,
and outputs a detailed report with all errors and warnings}
  gem.summary       = %q{command-line tool to validate the markup of a whole site against the W3C validator}
  gem.homepage      = "https://github.com/jaimeiniesta/w3clove/"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.name          = "w3clove"
  gem.require_paths = ["lib"]
  gem.version       = W3Clove::VERSION

  gem.add_dependency 'w3c_validators', '~> 1.2'
  gem.add_dependency 'nokogiri', '~> 1.5.3'
  gem.add_dependency 'metainspector', '1.9.10'

  gem.add_development_dependency 'rspec', '~> 2.5.0'
  gem.add_development_dependency 'mocha', '~> 0.11.4'
  gem.add_development_dependency 'rake', '~> 0.9.2'
  gem.add_development_dependency 'fakeweb', '~> 1.3.0'
end
