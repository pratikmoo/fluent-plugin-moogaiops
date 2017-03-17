# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-moogaiops"
  spec.authors       = ["stephen"]
  spec.email         = ["stephen@moogsoftcom"]

  spec.summary       = %q{Send Fluentd output to the Moog AIOps REST LAM}
  spec.description   = %q{Send Fluentd output to the Moog AIOps REST LAM}
  spec.homepage      = "https://github.com/moog-stephen/fluent-plugin-moogaiops"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.name          = "fluent-plugin-moogaiops"
  spec.version       = '0.1.0'
  spec.required_ruby_version = ">= 2.1.0"

  spec.add_dependency "fluentd", [">= 0.10.58", "< 2"]
  spec.add_dependency 'restclient'
  spec.add_dependency 'json'

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
