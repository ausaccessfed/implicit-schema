lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = 'implicit-schema'
  spec.version = '0.0.1'
  spec.authors = ['Shaun Mangelsdorf']
  spec.email   = ['s.mangelsdorf@gmail.com']

  spec.summary  = 'Lazily and implicitly validate Hash objects'
  spec.homepage = 'https://github.com/ausaccessfed/implicit-schema'
  spec.license  = 'Apache-2.0'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'guard-bundler'
end
