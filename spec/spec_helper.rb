# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

# Enable coverage tracking when the 'COVERAGE' environment variable is set
if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    # ignore the test files
    add_filter '/spec/'
    # ignore version testing due to loading in the `.gemspec` file causes issues.
    add_filter 'lib/minitest/have_tag/version.rb'

    # track all library files
    track_files 'lib/**/*.rb'
  end
end

# Ensure the library path is in the load path
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

# # Set up Bundler before loading gems
# require 'bundler/setup'

# Fix duplicate test runs when using Rake
require 'minitest'
Minitest::Runnable.runnables.clear

# Load Minitest
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/assert_errors'
# require 'minitest/hooks/default'
# require 'mocha/minitest'

# Load the code being tested
require 'minitest/have_tag'

# Add coloured output
require 'minitest/rg'
