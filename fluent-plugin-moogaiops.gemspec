# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-moogaiops"
  spec.authors       = ["stephen"]
  spec.email         = ["stephen@moogsoftcom"]

  spec.summary       = %q{Send Fluentd output to the Moog AIOps REST LAM}
  spec.description   = %q{Matcher (Output plugin) to send Fluentd events to the Moog AIOps REST LAM}
  spec.homepage      = "https://github.com/moog-stephen/fluent-plugin-moogaiops"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.name          = "fluent-plugin-moogaiops"
  spec.version       = '0.1.0'
  spec.required_ruby_version = ">= 2.1.0"

  spec.add_runtime_dependency "fluentd", [">= 0.12", "< 0.14"]
  spec.add_runtime_dependency 'restclient', "~> 2.0"
  spec.add_runtime_dependency 'json', "~> 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
