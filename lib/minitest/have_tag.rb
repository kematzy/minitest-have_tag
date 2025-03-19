# frozen_string_literal: false

require 'minitest'
require 'minitest/have_tag/version'
require 'nokogiri'

# rubocop:disable Style/Documentation
module Minitest::Assertions
  # Method to test for existence of HTML tag, including contents, within the provided string.
  #
  # This method asserts that a specific HTML tag or structure is present in the given HTML content.
  # It can check for tags, attributes, and even specific content.
  #
  # @param actual [String] The HTML content to be tested
  # @param expected [String] The CSS selector or tag to search for
  # @param contents [String, Regexp, nil] Optional. The expected contents of the tag
  # @param msg [String, nil] Optional. Custom error message
  #
  # @return [TrueClass] True if the tag is found and matches the criteria
  #
  # @example Basic usage
  #     assert_have_tag('<br>', 'br')
  #
  # @example Checking for CSS class
  #     assert_have_tag('<hr class="divider">', 'hr.divider')
  #     assert_have_tag('<hr class="divider">', 'hr[@class=divider]')
  #
  # @example Checking for CSS id
  #     assert_have_tag('<hr id="divider">', 'hr#divider')
  #     assert_have_tag('<hr id="divider">', 'hr[@id=divider]')
  #
  # @example Checking for specific content
  #     assert_have_tag('<div class="row">contents</div>', 'div.row', 'contents')
  #
  # @example Complex HTML structure
  #     html = <<-HTML
  #       <div id="intro" class="row">
  #         <div class="col-md-12">
  #           <h1>Header</h1>
  #         </div>
  #       </div>
  #     HTML
  #     assert_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
  #
  # @example Error message
  #     assert_have_tag('<br>', 'brr')
  #       # Raises error: 'Expected "<br>" to have tag ["brr"], but no such tag was found'
  #
  def assert_have_tag(actual, expected, contents = nil, msg = nil)
    msg = have_tag_build_message(msg, actual, expected)
    doc = have_tag_ensure_nokogiri_document(actual)
    res = doc.css(expected)

    if res.empty?
      msg << ', but no such tag was found'
      matching = false
    else
      matching = have_tag_check_contents(res, contents, msg)
    end
    assert matching, msg
  end

  # Method to test for non-existence of the expected HTML tag, including contents,
  # within the provided string.
  #
  # This method is used to assert that a specific HTML tag or structure is NOT present
  # in the given HTML content. It can check for tags, attributes, and even specific content.
  #
  # @param actual [String] The HTML content to be tested
  # @param expected [String] The CSS selector or tag to search for
  # @param contents [String, Regexp, nil] Optional. The expected contents of the tag
  # @param msg [String, nil] Optional. Custom error message
  #
  # @return [TrueClass] True if the assertion passes, otherwise raises an error
  #
  # @example Basic usage
  #     refute_have_tag('<abbr>', 'br')  # Passes
  #
  # @example Checking for CSS class
  #     refute_have_tag('<hr class="divider">', 'hr.space')  # Passes
  #     refute_have_tag('<hr class="divider">', 'hr[@class=space]')  # Passes
  #
  # @example Checking for CSS id
  #     refute_have_tag('<hr id="divider">', 'hr#space')  # Passes
  #     refute_have_tag('<hr id="divider">', 'hr[@id=space]')  # Passes
  #
  # @example Checking for specific content
  #     refute_have_tag('<div class="row">contents</div>', 'hr.row', '<h1>Header</h1>')  # Passes
  #
  # @example Complex HTML structure
  #     html = <<-HTML
  #       <div id="intro" class="row">
  #         <div class="col-md-12">
  #           <h1>Header</h1>
  #         </div>
  #       </div>
  #     HTML
  #     refute_have_tag(html, 'div#intro.row > .col-md-12 > h2', 'Header')  # Passes
  #
  # @example Error message
  #     refute_have_tag('<br>', 'br')
  #       # Raises error: 'Expected "<br>" to NOT have tag ["br"], but such a tag was found'
  #
  def refute_have_tag(actual, expected, contents = nil, msg = nil)
    msg = have_tag_build_message(msg, actual, expected, refute: true)
    doc = have_tag_ensure_nokogiri_document(actual)
    res = doc.css(expected)

    if res.empty?
      matching = false
    else
      msg << ', but such a tag was found'
      matching = have_tag_check_contents(res, contents, msg)
    end
    refute matching, msg
  end

  private

  # Builds an error message for tag assertions
  #
  # @param msg [String, nil] Custom error message
  # @param actual [String] The actual HTML content being tested
  # @param expected [String] The expected tag or selector
  # @param refute [Boolean] Whether this is for a refutation (default: false)
  #
  # @return [String] The formatted error message
  #
  def have_tag_build_message(msg, actual, expected, refute: false)
    msg = msg.nil? ? '' : "#{msg}\n"

    # Format the 'actual' value appropriately based on its type
    actual_display = have_tag_nokogiri_document?(actual) ? '[Nokogiri Document]' : actual.inspect

    msg << "Expected #{actual_display} to #{refute ? "NOT " : ""}have tag #{expected.inspect}"
  end

  # Checks the contents of the found tag against the expected contents
  #
  # @param res [Nokogiri::XML::NodeSet] The result of the CSS selector query
  # @param contents [String, Regexp, nil] The expected contents of the tag
  # @param msg [String] The error message to be appended to
  #
  # @return [Boolean] True if contents match, false otherwise
  #
  def have_tag_check_contents(res, contents, msg)
    return true unless contents

    if contents.is_a?(String)
      have_tag_check_string_contents(res, contents, msg)
    elsif contents.is_a?(Regexp)
      have_tag_check_regexp_contents(res, contents, msg)
    else
      msg << ", ERROR: contents is neither String nor Regexp, it's [#{contents.class}]"
      false
    end
  end

  # Checks if the inner HTML of the found tag exactly matches the expected string contents
  #
  # @param res [Nokogiri::XML::NodeSet] The result of the CSS selector query
  # @param contents [String] The expected contents of the tag
  # @param msg [String] The error message to be appended to
  #
  # @return [Boolean] True if contents match exactly, false otherwise
  #
  def have_tag_check_string_contents(res, contents, msg)
    if res.any? { |tag| tag.inner_html == contents }
      true
    else
      content_list = res.map(&:inner_html).join(', ')
      msg << " with expected contents [#{contents.inspect}], but found [#{content_list}]"
      false
    end
  end

  # Checks if the inner HTML of the found tag matches the expected regular expression
  #
  # @param res [Nokogiri::XML::NodeSet] The result of the CSS selector query
  # @param contents [Regexp] The expected regular expression to match against the tag's contents
  # @param msg [String] The error message to be appended to
  #
  # @return [Boolean] True if contents match the regular expression, false otherwise
  #
  def have_tag_check_regexp_contents(res, contents, msg)
    if res.any? { |tag| tag.inner_html.match?(contents) }
      true
    else
      content_list = res.map(&:inner_html).join(', ')
      msg << " with contents [#{content_list}],"
      msg << " but did not match Regexp [#{contents.inspect}]"
      false
    end
  end

  # Ensures we have a Nokogiri document to work with
  #
  # @param actual [String, Nokogiri::HTML::Document, Nokogiri::XML::Document]
  #        Either HTML string or Nokogiri document
  #
  # @return [Nokogiri::HTML::Document, Nokogiri::XML::Document] The Nokogiri document
  #
  def have_tag_ensure_nokogiri_document(actual)
    if have_tag_nokogiri_document?(actual)
      actual
    else
      Nokogiri::HTML(actual)
    end
  end

  # Checks if the given object is a Nokogiri document
  #
  # @param obj [Object] Object to check
  #
  # @return [Boolean] true if object is a Nokogiri document
  #
  def have_tag_nokogiri_document?(obj)
    obj.is_a?(Nokogiri::HTML::Document) || obj.is_a?(Nokogiri::XML::Document)
  end
end
# rubocop:enable Style/Documentation

# add support for Spec syntax
module Minitest::Expectations
  infect_an_assertion :assert_have_tag, :must_have_tag, :reverse
  infect_an_assertion :refute_have_tag, :wont_have_tag, :reverse
end
