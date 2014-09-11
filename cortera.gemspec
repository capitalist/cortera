# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cortera/version'

Gem::Specification.new do |spec|
  spec.name          = "cortera"
  spec.version       = Cortera::VERSION
  spec.authors       = ["Joe Martinez"]
  spec.email         = ["joe@joemartinez.name"]
  spec.summary       = %q{Client for the Cortera JSON API}
  spec.description   = %q{Client for the Cortera JSON API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'json'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
end
