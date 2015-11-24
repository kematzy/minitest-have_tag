ENV['RACK_ENV'] = 'test'
if ENV['COVERAGE']
  require File.join(File.dirname(File.expand_path(__FILE__)), 'minitest_have_tags_coverage')
  SimpleCov.minitest_have_tags_coverage
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'minitest/autorun'
require 'minitest/have_tag'
# require 'minitest/hooks/default'
require 'minitest/rg'


module Minitest::Assertions
  
  # 
  def assert_returns_error(expected_msg, klass = Minitest::Assertion, &blk)
    e = assert_raises(klass) do
      yield
    end
    assert_match(expected_msg, e.message) if expected_msg.is_a?(Regexp)
    assert_equal(expected_msg, e.message) if expected_msg.is_a?(String)
  end
  
  # 
  def assert_no_error(&blk)
    e = assert_silent do
      yield
    end
  end
  
end
