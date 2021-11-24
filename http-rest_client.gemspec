lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http/rest_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'http-rest_client'
  spec.version       = HTTP::RestClient::VERSION
  spec.authors       = ['Stas SUȘCOV']
  spec.email         = ['stas@nerd.ro']

  spec.summary       = 'An easy to use HTTP/REST client'
  spec.description   = 'A HTTP/REST Client to help you wrap APIs easily.'
  spec.homepage      = 'https://github.com/stas/http-rest_client'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.6'

  spec.files         = Dir['README.md', 'LICENSE.txt', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.metadata      = { 'rubygems_mfa_required' => 'true' }

  spec.add_dependency 'http'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yardstick'
end
