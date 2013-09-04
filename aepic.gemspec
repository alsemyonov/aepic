# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aepic/version'

Gem::Specification.new do |spec|
  spec.name          = 'aepic'
  spec.version       = Aepic::VERSION
  spec.authors       = ['Alexander Semyonov']
  spec.email         = %w(al@semyonov.us)
  spec.description   = %q{Build your epic APIs same time you are building your website. Docs included}
  spec.summary       = %q{Æpic is for your epic APIs}
  spec.homepage      = 'http://github.com/alsemyonov/aepic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'actionpack', '>= 3.2'
  spec.add_runtime_dependency 'active_model_serializers'
  spec.add_runtime_dependency 'inherited_resources'
  spec.add_runtime_dependency 'has_scope'
  spec.add_runtime_dependency 'responders'
  spec.add_runtime_dependency 'draper'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end