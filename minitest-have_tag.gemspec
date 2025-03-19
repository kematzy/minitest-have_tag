# frozen_string_literal: true

# Load the version number
# NOTE! this load marks the file as executed before the SimpleCov code coverage tests
# which may result in either 0%, or 100% coverage even it has (not?) been tested.
require_relative 'lib/minitest/have_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'minitest-have_tag'
  spec.version       = Minitest::HaveTag::VERSION
  spec.authors       = ['Kematzy']
  spec.email         = ['kematzy@gmail.com']

  spec.summary       = 'Minitest assertions for testing HTML output'
  spec.description   = 'Adds Minitest assertion for testing HTML output, including contents, within a provided string'
  spec.homepage      = 'http://github.com/kematzy/minitest-have_tag'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kematzy/minitest-have_tag'
  spec.metadata['documentation_uri'] = 'https://github.com/kematzy/minitest-have_tag'
  spec.metadata['changelog_uri'] = 'https://github.com/kematzy/minitest-have_tag/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.require_paths = ['lib']

  spec.platform         = Gem::Platform::RUBY
  spec.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  spec.rdoc_options += ['--quiet', '--line-numbers', '--inline-source', '--title',
                        'Minitest::HaveTag: assertions for testing HTML output', '--main', 'README.md']

  # register dependencies
  spec.add_dependency('minitest', '>= 5.20.0', '< 6.0')
  spec.add_dependency('nokogiri')

  # development dependencies are found in the Gemfile

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
