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
  spec.required_ruby_version = '>= 3.0.0'

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

  spec.platform         = Gem::Platform::RUBY
  spec.extra_rdoc_files = ['README.md', 'MIT-LICENSE']
  spec.rdoc_options += ['--quiet', '--line-numbers', '--inline-source', '--title',
                        'Minitest::HaveTag: assertions for testing HTML output', '--main', 'README.md']

  spec.add_dependency('minitest', '~> 5.7', '>= 5.7.0')
  spec.add_dependency('nokogiri')

  spec.metadata['rubygems_mfa_required'] = 'true'
end
