ENV['RACK_ENV'] = 'test'
if ENV['COVERAGE']
  require File.join(File.dirname(File.expand_path(__FILE__)), 'minitest_have_tags_coverage')
  SimpleCov.minitest_have_tags_coverage
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'minitest/autorun'
require 'minitest/have_tag'
require 'minitest/assert_errors'
# require 'minitest/hooks/default'
require 'minitest/rg'


