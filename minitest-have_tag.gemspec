# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'minitest/have_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'minitest-have_tag'
  spec.version       = Minitest::HaveTag::VERSION
  spec.authors       = ['Kematzy']
  spec.email         = ['kematzy@gmail.com']

  spec.summary       = 'Minitest assertions for testing HTML output'
  spec.description   = [
    'Adds Minitest assertion for testing HTML output, including contents, within a provided string'
  ]
  spec.homepage      = 'http://github.com/kematzy/minitest-have_tag'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'minitest'
  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler' # , '~> 1.10'
  spec.add_development_dependency 'rake' # , '~> 10.0'
  # spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-assert_errors'
  spec.add_development_dependency 'minitest-hooks'
  spec.add_development_dependency 'minitest-rg'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'simplecov'
end
